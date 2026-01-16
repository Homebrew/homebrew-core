class Azurite < Formula
  desc "Lightweight server clone of Azure Storage that simulates it locally"
  homepage "https://github.com/Azure/Azurite"
  url "https://registry.npmjs.org/azurite/-/azurite-3.35.0.tgz"
  sha256 "6c04d7a78b0f41eb7b82004a9be640a1aab722137aa1801813eb06263576f753"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b6c97acb5b1302435b24071f37b2583f4fd6bb87377f1051a69bf1d556c8a52b"
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
