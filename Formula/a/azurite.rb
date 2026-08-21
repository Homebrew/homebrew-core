class Azurite < Formula
  desc "Lightweight server clone of Azure Storage that simulates it locally"
  homepage "https://github.com/Azure/Azurite"
  url "https://registry.npmjs.org/azurite/-/azurite-3.36.0.tgz"
  sha256 "b33f3373449b0b9cc716cafe293a4d1ba6adfdad37ff2c816a3fafbdcbf50f9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a1054eb19d6d8651c26f3fa66f575861559fe572c1fcd92cd7af96a05590b1c"
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
