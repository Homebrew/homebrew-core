class Moco < Formula
  desc "Stub server with Maven, Gradle, Scala, and shell integration"
  homepage "https://github.com/dreamhead/moco"
  url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/1.5.0/moco-runner-1.5.0-standalone.jar"
  sha256 "67fffbf936877012e7ecd754cb72c6e1908ca38cf1cc0140c79fd6ab81da2ef1"
  license "MIT"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be22300213a664c3a18e3912937f148ad920c5de419507e2d4899fe9d49d88b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be22300213a664c3a18e3912937f148ad920c5de419507e2d4899fe9d49d88b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be22300213a664c3a18e3912937f148ad920c5de419507e2d4899fe9d49d88b5"
    sha256 cellar: :any_skip_relocation, ventura:        "be22300213a664c3a18e3912937f148ad920c5de419507e2d4899fe9d49d88b5"
    sha256 cellar: :any_skip_relocation, monterey:       "be22300213a664c3a18e3912937f148ad920c5de419507e2d4899fe9d49d88b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "be22300213a664c3a18e3912937f148ad920c5de419507e2d4899fe9d49d88b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a04f771c06da8df507698deb1da9aedeecef6a1b455ebe5e8431a1495a9da545"
  end

  depends_on "openjdk"

  def install
    libexec.install "moco-runner-#{version}-standalone.jar"
    bin.write_jar_script libexec/"moco-runner-#{version}-standalone.jar", "moco"
  end

  test do
    (testpath/"config.json").write <<~EOS
      [
        {
          "response" :
          {
              "text" : "Hello, Moco"
          }
        }
      ]
    EOS

    port = free_port
    begin
      pid = fork do
        exec "#{bin}/moco http -p #{port} -c #{testpath}/config.json"
      end
      sleep 10

      assert_match "Hello, Moco", shell_output("curl -s http://127.0.0.1:#{port}")
    ensure
      Process.kill "SIGTERM", pid
      Process.wait pid
    end
  end
end
