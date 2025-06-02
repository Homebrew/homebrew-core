class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://jetty.org/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.57.v20241219/jetty-distribution-9.4.57.v20241219.tar.gz"
  version "9.4.57.v20241219"
  sha256 "1cfc73128848282f1f7220660fc191be09b6a1c184e02587c46f189212ed9681"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+(?:[._-]v?\d+)?)</version>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7e7c790eaeadb9bd6e0ef648117963620bc9515c80a46285206c9c409a3e879a"
    sha256 cellar: :any,                 arm64_sonoma:  "601f49357f56efe738abdd75c5d08e180c953fbdde53b84c0d5e99709a89ff94"
    sha256 cellar: :any,                 arm64_ventura: "9856be3e6041b17203fe6053cd0740fe906b7f8f0a41d4042e2d3539b69dc787"
    sha256 cellar: :any,                 sonoma:        "4168e1d01e872605f106067c547b1bcf78354df0975d5937571d911658135ca0"
    sha256 cellar: :any,                 ventura:       "4168e1d01e872605f106067c547b1bcf78354df0975d5937571d911658135ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9dbbb51964c592d7b53a3aefb6ab3ced9dd94bcfbcf00277a80a97322889b0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8b9972b6503efa46f902c552d6760d9196a9f1d136ca2d1d37238f9a9e82c15"
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
      sha256 "9a19e7f3c947bbc1979cfef1f8dfc038fb0df4aa518396b9b84b44c69b79332f"

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
