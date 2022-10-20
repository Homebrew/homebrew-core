class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.49.v20220914/jetty-distribution-9.4.49.v20220914.tar.gz"
  version "9.4.49.v20220914"
  sha256 "a8c9e372f16e56fa0967ef36de72aebeeea8477ca123638420f7e866b39513fd"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://www.eclipse.org/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "f5579d086de7aa2364b4b3bed97b0d1fb0b5e503249ac8af1aaa8317bacf6c88"
    sha256 cellar: :any,                 big_sur:      "f5579d086de7aa2364b4b3bed97b0d1fb0b5e503249ac8af1aaa8317bacf6c88"
    sha256 cellar: :any,                 catalina:     "f5579d086de7aa2364b4b3bed97b0d1fb0b5e503249ac8af1aaa8317bacf6c88"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8533506b9adbcbc7de65fa95c7e08abd12e3585ca403db885778bad9fb58b61e"
  end

  # Ships a pre-built x86_64-only `libsetuid-osx.so`.
  depends_on arch: :x86_64
  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (libexec/"logs").mkpath

    env = Language::Java.overridable_java_home_env
    env["JETTY_HOME"] = libexec
    Dir.glob(libexec/"bin/*.sh") do |f|
      (bin/File.basename(f, ".sh")).write_env_script f, env
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
  end
end
