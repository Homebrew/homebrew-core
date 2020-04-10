class Moco < Formula
  desc "Stub server with Maven, Gradle, Scala, and shell integration"
  homepage "https://github.com/dreamhead/moco"
  url "https://search.maven.org/remotecontent?filepath=com/github/dreamhead/moco-runner/1.1.0/moco-runner-1.1.0-standalone.jar"
  sha256 "cf970d4a74b834e8fc0df2059368c2d153924bb37c34f6a8cef5b8d886e71463"

  bottle :unneeded

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
