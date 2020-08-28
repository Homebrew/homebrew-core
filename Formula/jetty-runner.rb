class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/9.4.31.v20200723/jetty-runner-9.4.31.v20200723.jar"
  version "9.4.31.v20200723"
  sha256 "70d8572a252017f2a97ddfde86d90b0d2d90ddd607bad8a75edaa27a05fb1e33"
  revision 1

  livecheck do
    url "https://www.eclipse.org/jetty/download.html"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle :unneeded

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
    sleep 5

    begin
      output = shell_output("curl -I http://localhost:#{port}")
      assert_match %r{HTTP/1\.1 200 OK}, output
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
