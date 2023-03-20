class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.51.v20230217/jetty-distribution-9.4.51.v20230217.tar.gz"
  version "9.4.51.v20230217"
  sha256 "5c34101bfb56b90c546df9b04f7931822b8f9bed676e02dc8c7c91b02a7f38b7"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://www.eclipse.org/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d228e1b73584d5d9eee674e2ad77c5bb3b4b9fa3b33e515c12d9e24c2301af91"
    sha256 cellar: :any,                 arm64_monterey: "af0e1498c5bfbc9c05e728edfac77da8cb49c617554a149fe45ef9c499f5530e"
    sha256 cellar: :any,                 arm64_big_sur:  "ec74afc2299e03f8241ba5e14a4008768e3c654db05f5beabe547714d71adaa5"
    sha256 cellar: :any,                 ventura:        "ee8afdb5a427644b41e8678220c2661d0dc34538488033d5f8c8c9081cddc175"
    sha256 cellar: :any,                 monterey:       "ee8afdb5a427644b41e8678220c2661d0dc34538488033d5f8c8c9081cddc175"
    sha256 cellar: :any,                 big_sur:        "ee8afdb5a427644b41e8678220c2661d0dc34538488033d5f8c8c9081cddc175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e13e171d78c9c7ea3d9493a3edf75f6ec44854603608e6a4fa05345af183c9fe"
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
