class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://jetty.org/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.56.v20240826/jetty-distribution-9.4.56.v20240826.tar.gz"
  version "9.4.56.v20240826"
  sha256 "02f5f9c4f6b4be0e5b2640d4b5a21e2838d68143ef96c540c2ba39885b60cb62"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+(?:[._-]v?\d+)?)</version>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ee8fc6c28fc7bc7ac22aa43cedcab32819748f6310ed872f9f13fb10c2ca25ef"
    sha256 cellar: :any,                 arm64_sonoma:   "5622e26be94cf6fbf2fa9aa661be7b61fb4f14b7155da56e4d2fe383b42a814c"
    sha256 cellar: :any,                 arm64_ventura:  "ed58636aa91cdb805775655aed8774586501c8812bf3b1179168ede42d7a1daa"
    sha256 cellar: :any,                 arm64_monterey: "d09f9bad8c3058f27ea082fe55c54b7fb10d1b1002736403196b2966257d683a"
    sha256 cellar: :any,                 sonoma:         "dbe2190466ae89ba0a9f5941d97b0c55daac1f3e8d813b7058c95464d3a74608"
    sha256 cellar: :any,                 ventura:        "dbe2190466ae89ba0a9f5941d97b0c55daac1f3e8d813b7058c95464d3a74608"
    sha256 cellar: :any,                 monterey:       "dbe2190466ae89ba0a9f5941d97b0c55daac1f3e8d813b7058c95464d3a74608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b083679cf60b33f9dfadb7aa8116413ea10660c726afaadaef3300269885d03b"
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
