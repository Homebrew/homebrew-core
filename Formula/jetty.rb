class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-distribution/9.4.48.v20220622/jetty-distribution-9.4.48.v20220622.tar.gz"
  version "9.4.48.v20220622"
  sha256 "50d6eccd349d2e671bfea710cee833911287eb706fe1d39503eab76fc6fc1a0c"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://www.eclipse.org/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "e03072df8acd66171e1916dfd05883610faa74a50a323cd07ad79698a8c46fc5"
    sha256 cellar: :any,                 big_sur:      "e03072df8acd66171e1916dfd05883610faa74a50a323cd07ad79698a8c46fc5"
    sha256 cellar: :any,                 catalina:     "e03072df8acd66171e1916dfd05883610faa74a50a323cd07ad79698a8c46fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e89783e620e008ec57e836acec85afbea839a98caf8b0c44bdb5e442567ef142"
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
