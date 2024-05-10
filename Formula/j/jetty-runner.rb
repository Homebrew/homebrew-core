class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://eclipse.dev/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/9.4.54.v20240208/jetty-runner-9.4.54.v20240208.jar"
  version "9.4.54.v20240208"
  sha256 "53fd433d18f4de5e87d78fa75ce8633e1533df2284fe1e4bb9beaedd17b30650"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://eclipse.dev/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d0f94bfaac4692da8fe92064e92d1154bad252d05e37a3e6209c96d680a8d4e"
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
