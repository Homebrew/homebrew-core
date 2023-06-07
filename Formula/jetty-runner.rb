class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/9.4.51.v20230217/jetty-runner-9.4.51.v20230217.jar"
  version "9.4.51.v20230217"
  sha256 "ac33a1e7fa73c28c8877feade26a853abf5a6419a75e2156038fb2379a12cdc5"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://www.eclipse.org/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17e72d7c303faad3cff674691d9657eeaf4a01db71087cb7d49a78eb6bd8559f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17e72d7c303faad3cff674691d9657eeaf4a01db71087cb7d49a78eb6bd8559f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17e72d7c303faad3cff674691d9657eeaf4a01db71087cb7d49a78eb6bd8559f"
    sha256 cellar: :any_skip_relocation, ventura:        "17e72d7c303faad3cff674691d9657eeaf4a01db71087cb7d49a78eb6bd8559f"
    sha256 cellar: :any_skip_relocation, monterey:       "17e72d7c303faad3cff674691d9657eeaf4a01db71087cb7d49a78eb6bd8559f"
    sha256 cellar: :any_skip_relocation, big_sur:        "17e72d7c303faad3cff674691d9657eeaf4a01db71087cb7d49a78eb6bd8559f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcf4ff31ae4fba559f3cc6d157632a936e6c29e39be665a4521964b7cd7f3fdf"
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
