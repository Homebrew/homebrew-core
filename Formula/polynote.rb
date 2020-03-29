class Polynote < Formula
  desc "The polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.3.0/polynote-dist.tar.gz"
  version "0.3.0"
  sha256 "b0ad435bd93b36ffcf07da2de5ab1755c02953d902892c5e4a2948144ca5b92f"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]

    (bin/"polynote").write_env_script libexec/"polynote", Language::Java.overridable_java_home_env
  end

  test do
    mkdir testpath/"notebooks"

    assert_predicate bin/"polynote", :exist?
    assert_predicate bin/"polynote", :executable?

    output = shell_output("#{bin}/polynote version 2>&1", 1)
    assert_match "Unknown command version", output

    (testpath/"config.yml").write <<~EOS
      listen:
        host: 127.0.0.1
        port: 8080
      storage:
        dir: #{testpath}/notebooks
    EOS

    begin
      pid = fork do
        exec bin/"polynote", "--config", "#{testpath}/config.yml"
      end
      sleep 5

      assert_match "<title>Polynote</title>", shell_output("curl -s 127.0.0.1:8080")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
