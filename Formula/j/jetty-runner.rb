class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://jetty.org/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/11.0.24/jetty-runner-11.0.24.jar"
  sha256 "4f00fac144cc16ef3e628e678d808f6979a662e39f55087ed124b59bfcdb0933"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+(?:[._-]v?\d+)?)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a758369d5fc8879cea803b07635e425dba98faeca8367e5f3e7d0a9dd396f44d"
  end

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
