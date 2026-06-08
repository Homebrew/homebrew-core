class Moco < Formula
  desc "Stub server with Maven, Gradle, Scala, and shell integration"
  homepage "https://github.com/dreamhead/moco"
  url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/1.6.1/moco-runner-1.6.1-standalone.jar"
  sha256 "f61ea62275e2b11590472b74de933a65f62ea05ff4de8b94f6b06173773301b1"
  license "MIT"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75d231201d51d05d699392664c9d9a3bd979c863dcb09e6a75ed646251975019"
  end

  depends_on "openjdk"

  def install
    libexec.install "moco-runner-#{version}-standalone.jar"
    bin.write_jar_script libexec/"moco-runner-#{version}-standalone.jar", "moco"
  end

  test do
    (testpath/"config.json").write <<~JSON
      [
        {
          "response" :
          {
              "text" : "Hello, Moco"
          }
        }
      ]
    JSON

    port = free_port
    pid = spawn bin/"moco", "http", "-p", port.to_s, "-c", testpath/"config.json"
    begin
      sleep 10
      assert_match "Hello, Moco", shell_output("curl -s http://127.0.0.1:#{port}")
    ensure
      Process.kill "SIGTERM", pid
      Process.wait pid
    end
  end
end
