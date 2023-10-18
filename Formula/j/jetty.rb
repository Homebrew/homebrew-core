class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://eclipse.dev/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.53.v20231009/jetty-distribution-9.4.53.v20231009.tar.gz"
  version "9.4.53.v20231009"
  sha256 "b04b4cd45f3bf3c09a26bdf7f4e8d1a67e1a0f224ef4539534a0719b2c701088"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://eclipse.dev/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5fffc6f15718803b8dcc764ff13cbc61a10fc128417be08c48dcd7dbfe42e1d"
    sha256 cellar: :any,                 arm64_ventura:  "9f31eb94e8d32dfd058f8071e26b7b996a6975791431d849d2d8f24805b20ea1"
    sha256 cellar: :any,                 arm64_monterey: "bf51d82b8dd6e43cd93fe26c7c68100c543fe5c1b273c45b4934b87ac8c87f69"
    sha256 cellar: :any,                 sonoma:         "3aeb681cc6b461148b61096cdfb64abbce798d9f1dfaa9e8bc4bf9cf0d80238e"
    sha256 cellar: :any,                 ventura:        "3aeb681cc6b461148b61096cdfb64abbce798d9f1dfaa9e8bc4bf9cf0d80238e"
    sha256 cellar: :any,                 monterey:       "3aeb681cc6b461148b61096cdfb64abbce798d9f1dfaa9e8bc4bf9cf0d80238e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fc69f390679f6e27fd1bdb1aaae2a23e1fb95ffd9536abd7bf46385369d2fff"
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
