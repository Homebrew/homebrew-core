class Moco < Formula
  desc "Stub server with Maven, Gradle, Scala, and shell integration"
  homepage "https://github.com/dreamhead/moco"
  url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/1.4.0/moco-runner-1.4.0-standalone.jar"
  sha256 "c51892b292fdcf37cf69368625adfa22f9a851b931bc89142933a2754ca167d7"
  license "MIT"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0fb213ecaed30f0f05c038e927f1b773d1de0e4312702e3141d2da6ff515eb48"
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
