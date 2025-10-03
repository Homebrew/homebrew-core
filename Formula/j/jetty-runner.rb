class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://jetty.org/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/11.0.26/jetty-runner-11.0.26.jar"
  sha256 "b6403baf0782c2154231b23109fb84247e2ee95d295f4621ca9bdc75dfebc762"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+(?:[._-]v?\d+)?)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8958471cd8133f453afbee348c696884a56eaaa493ecf224beab6d7d57887dbd"
  end

  # See: https://github.com/jetty/jetty.project/issues/1905#issuecomment-409662335
  deprecate! date: "2018-08-02", because: :deprecated_upstream

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"jetty-runner-#{version}.jar", "jetty-runner"
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    touch "#{testpath}/test.war"

    port = free_port
    pid = fork do
      exec "#{bin}/jetty-runner --port #{port} test.war"
    end
    sleep 10

    begin
      output = shell_output("curl -I http://localhost:#{port}")
      assert_match %r{HTTP/1\.1 200 OK}, output
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
