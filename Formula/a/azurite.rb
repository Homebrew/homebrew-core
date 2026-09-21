class Azurite < Formula
  desc "Lightweight server clone of Azure Storage that simulates it locally"
  homepage "https://github.com/Azure/Azurite"
  url "https://registry.npmjs.org/azurite/-/azurite-3.37.0.tgz"
  sha256 "991f93cbfd9006d61f8708a7ff78f4f76ce90ff8ee1dfb76ba47de2323170065"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e0d2b9196a3bdedae60f932a3857e3119b445501a692c31e1faf5d5f21f2680e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurite --version")

    blob_port = free_port.to_s
    queue_port = free_port.to_s
    table_port = free_port.to_s

    pid = spawn bin/"azurite", "--location", testpath/"data",
                               "--debug", testpath/"log.txt",
                               "--blobPort", blob_port,
                               "--queuePort", queue_port,
                               "--tablePort", table_port

    sleep 2

    assert_match "Azurite Blob service is starting", (testpath/"log.txt").read
    assert_path_exists testpath/"log.txt"

    assert_match "InvalidQueryParameterValue", shell_output("curl --silent http://127.0.0.1:#{blob_port} 2>&1")
    shell_output("curl --silent http://127.0.0.1:#{queue_port} 2>&1")
    shell_output("curl --silent http://127.0.0.1:#{table_port} 2>&1")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid)
  end
end
