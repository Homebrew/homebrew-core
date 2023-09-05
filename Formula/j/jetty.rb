class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://eclipse.dev/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.52.v20230823/jetty-distribution-9.4.52.v20230823.tar.gz"
  version "9.4.52.v20230823"
  sha256 "bd0ca75c520cbf28b901449e1a10cb6cad8cbe1262d3948cec7e809a44a146a6"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://eclipse.dev/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f3b6f94fc5ca6bd5c8eeed03ba584ce31a4cf4ec02188fe4168d29bc530009dd"
    sha256 cellar: :any,                 arm64_monterey: "37609fc201d7767a7325e61bd9a6131df4ecc06dc31b97ccec8fc8b568141947"
    sha256 cellar: :any,                 arm64_big_sur:  "a269520bbf2ac1046184872de4388e72102b9d23a42958369f0f59fee7d38cd9"
    sha256 cellar: :any,                 ventura:        "991eda4ae9731fc9fa98ce0a28c23635f8570f612943bdc5eeef81b3a1e568b1"
    sha256 cellar: :any,                 monterey:       "991eda4ae9731fc9fa98ce0a28c23635f8570f612943bdc5eeef81b3a1e568b1"
    sha256 cellar: :any,                 big_sur:        "991eda4ae9731fc9fa98ce0a28c23635f8570f612943bdc5eeef81b3a1e568b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f7dbe270adda111cfa5dcbec84a6987ea83d32fd03a5f9c1890e147e25a2621"
  end

  depends_on "openjdk"

  on_arm do
    depends_on "maven" => :build

    # We get jetty-setuid source code from the jetty.toolchain repo to build a native ARM binary.
    # The last jetty-setuid-1.0.4 release has some issues building, so we pick a more recent commit.
    # The particular commit was selected as it aligned to jetty version at time of PR.
    # Once 1.0.5 is available, we can switch to stable versions. Afterward, the version should
    # probably match the jetty-setuid version that is included with jetty.
    resource "jetty.toolchain" do
      url "https://github.com/eclipse/jetty.toolchain/archive/ce0f110e0b95baf85775897aa90f5b6c0cc6cd4d.tar.gz"
      sha256 "06a3ac033e5c4cc05716e7d362de7257e73aad1783b297bd57b6e0f7661555ab"

      # Fix header paths on macOS to follow modern JDKs rather than old system Java.
      # PR ref: https://github.com/eclipse/jetty.toolchain/pull/211
      patch do
        url "https://github.com/eclipse/jetty.toolchain/commit/4c3744d79f414f43fe45636fdabd5595f17daab6.patch?full_index=1"
        sha256 "6a7f3f16f7fb5f3d8ccf1562612da0d1091049bbafa4a0bf2ff0754551743312"
      end
    end
  end

  def install
    libexec.install Dir["*"]
    (libexec/"logs").mkpath

    env = Language::Java.overridable_java_home_env
    env["JETTY_HOME"] = libexec
    Dir.glob(libexec/"bin/*.sh") do |f|
      (bin/File.basename(f, ".sh")).write_env_script f, env
    end
    return if Hardware::CPU.intel?

    # We build a native ARM libsetuid to enable Jetty's SetUID feature.
    # https://www.eclipse.org/jetty/documentation/jetty-9/index.html#configuring-jetty-setuid-feature
    libexec.glob("lib/setuid/libsetuid-*.so").map(&:unlink)
    resource("jetty.toolchain").stage do
      cd "jetty-setuid"
      system "mvn", "clean", "install", "-Penv-#{OS.mac? ? "mac" : "linux"}"
      libsetuid = "libsetuid-#{OS.mac? ? "osx" : "linux"}"
      (libexec/"lib/setuid").install "#{libsetuid}/target/#{libsetuid}.so"
    end
  end

  test do
    http_port = free_port
    ENV["JETTY_ARGS"] = "jetty.http.port=#{http_port} jetty.ssl.port=#{free_port}"
    ENV["JETTY_BASE"] = testpath
    ENV["JETTY_RUN"] = testpath
    cp_r Dir[libexec/"demo-base/*"], testpath

    log = testpath/"jetty.log"
    pid = fork do
      $stdout.reopen(log)
      $stderr.reopen(log)
      exec bin/"jetty", "run"
    end

    begin
      sleep 20 # grace time for server start
      assert_match "webapp is deployed. DO NOT USE IN PRODUCTION!", log.read
      assert_match "Welcome to Jetty #{version.major}", shell_output("curl --silent localhost:#{http_port}")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end

    # Do a basic check that SetUID can run native library. Actually running command
    # requires creating a separate user account and running with sudo
    java = Formula["openjdk"].opt_bin/"java"
    system java, "-jar", libexec/"start.jar", "--add-to-start=setuid"
    output = shell_output("#{java} -Djava.library.path=#{libexec}/lib/setuid -jar #{libexec}/start.jar 2>&1", 254)
    refute_match "java.lang.UnsatisfiedLinkError", output
    assert_match "User jetty is not found", output
  end
end
