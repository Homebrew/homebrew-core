class Jetty < Formula
  desc "Java servlet engine and webserver"
  homepage "https://jetty.org/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-home/12.0.21/jetty-home-12.0.21.tar.gz"
  sha256 "53f5ba8744bb6f4ccba186a10c6a3fa6429af8d20c291d2d897de9c91978d338"
  license any_of: ["Apache-2.0", "EPL-2.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-home/maven-metadata.xml"
    regex(%r{<version>(\d+\.\d+\.\d+)(?!\.[a-zA-Z])</version>}i)
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

  def install
    libexec.install Dir["*"]
    (libexec/"logs").mkpath

    (bin/"jetty").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      export JETTY_HOME="#{libexec}"
      exec "${JAVA_HOME}/bin/java" -jar "${JETTY_HOME}/start.jar" "$@"
    EOS
  end

  test do
    http_port = free_port
    ENV["JETTY_ARGS"] = "jetty.http.port=#{http_port} jetty.ssl.port=#{free_port}"
    ENV["JETTY_BASE"] = testpath
    ENV["JETTY_RUN"] = testpath

    log = testpath/"jetty.log"

    # Add the `demos` module to the "JETTY_BASE" (testpath) for testing.
    system "#{bin}/jetty --add-module=demos > #{log} 2>&1"
    assert_match "Base directory was modified", log.read

    pid = fork do
      $stdout.reopen(log, "a")
      $stderr.reopen(log, "a")
      exec bin/"jetty", *ENV["JETTY_ARGS"].split
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
