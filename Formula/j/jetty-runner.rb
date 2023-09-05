class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://eclipse.dev/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/9.4.52.v20230823/jetty-runner-9.4.52.v20230823.jar"
  version "9.4.52.v20230823"
  sha256 "371b037770ffed0ff1cbe9aeed567ecbcf69c0477222dbd6367f4401e4ad6be7"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://eclipse.dev/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21f8207c7576f0469caabae4483eeddc35e3bd707f5205463cc5b42087b1faac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21f8207c7576f0469caabae4483eeddc35e3bd707f5205463cc5b42087b1faac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21f8207c7576f0469caabae4483eeddc35e3bd707f5205463cc5b42087b1faac"
    sha256 cellar: :any_skip_relocation, ventura:        "21f8207c7576f0469caabae4483eeddc35e3bd707f5205463cc5b42087b1faac"
    sha256 cellar: :any_skip_relocation, monterey:       "21f8207c7576f0469caabae4483eeddc35e3bd707f5205463cc5b42087b1faac"
    sha256 cellar: :any_skip_relocation, big_sur:        "21f8207c7576f0469caabae4483eeddc35e3bd707f5205463cc5b42087b1faac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9196e9c3b9cc601b696dcc4dd4a73ef7184ac1403152111a384a0c00ad002e7"
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
