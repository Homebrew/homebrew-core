class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/9.4.10.v20180503/jetty-runner-9.4.10.v20180503.jar"
  version "9.4.10.v20180503"
  sha256 "eabf90e6afa668abbe6cfd9a1738ed95b5c6645889bc56bf578b227c33af232b"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]

    bin.mkpath
    bin.write_jar_script libexec/"jetty-runner-#{version}.jar", "jetty-runner"
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    touch "#{testpath}/test.war"

    pid = fork do
      exec "#{bin}/jetty-runner test.war"
    end
    sleep 5

    begin
      output = shell_output("curl -I http://localhost:8080")
      assert_match %r{HTTP\/1\.1 200 OK}, output
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
