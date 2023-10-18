class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://eclipse.dev/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/9.4.53.v20231009/jetty-runner-9.4.53.v20231009.jar"
  version "9.4.53.v20231009"
  sha256 "4e8f17b281cb6682675086daced3191cd826830496ee4ad8befa6d684f2a925d"
  license any_of: ["Apache-2.0", "EPL-1.0"]

  livecheck do
    url "https://eclipse.dev/jetty/download.php"
    regex(/href=.*?jetty-distribution[._-]v?(\d+(?:\.\d+)+(?:\.v\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bb898cb6711d18f5193ab6af64ff3aa0ebe929c1f906ba5a45a09ff170c921e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bb898cb6711d18f5193ab6af64ff3aa0ebe929c1f906ba5a45a09ff170c921e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bb898cb6711d18f5193ab6af64ff3aa0ebe929c1f906ba5a45a09ff170c921e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bb898cb6711d18f5193ab6af64ff3aa0ebe929c1f906ba5a45a09ff170c921e"
    sha256 cellar: :any_skip_relocation, ventura:        "3bb898cb6711d18f5193ab6af64ff3aa0ebe929c1f906ba5a45a09ff170c921e"
    sha256 cellar: :any_skip_relocation, monterey:       "3bb898cb6711d18f5193ab6af64ff3aa0ebe929c1f906ba5a45a09ff170c921e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e89ca81cdc965afb1b8a79067653a87e81e5b38599cbbe582a63d844d2fc6ec"
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
