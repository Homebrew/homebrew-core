class Moco < Formula
  desc "Stub server with Maven, Gradle, Scala, and shell integration"
  homepage "https://github.com/dreamhead/moco"
  url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/1.2.0/moco-runner-1.2.0-standalone.jar"
  sha256 "7d5bcbed4cf39a960fb523d8b4c073579c3cdca1b3971901be751b7afc9f37fe"
  license "MIT"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "856cb9381f9a8d2941327ba84c0c11978bb7d3aefe5aa04d4e5f451e3fd86571"
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
