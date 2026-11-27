class Azurite < Formula
  desc "Lightweight server clone of Azure Storage that simulates it locally"
  homepage "https://github.com/Azure/Azurite"
  url "https://registry.npmjs.org/azurite/-/azurite-3.38.0.tgz"
  sha256 "2b5549bd7a53fa8550b6e9000a7cd60f9b7172efb490fce516560e446eabc181"
  license "MIT"

  bottle do
    manifest_sha256 "f9deb9cac24e57a6bba3b44e2ce2e5d4ee31c993eb3b7c1b84e54e7575b1004c"
    sha256 cellar: :any_skip_relocation, all: "3cedd02627114013d39f06a10be64e79985b09293c267f6d9f26e3e24cc9c6e5"
  end

  depends_on "node"

  allow_network_access! [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurite --version")

    blob_port = free_port.to_s
    queue_port = free_port.to_s
    table_port = free_port.to_s

    with_test_process(bin/"azurite", "--location", testpath/"data",
                                     "--debug", testpath/"log.txt",
                                     "--blobPort", blob_port,
                                     "--queuePort", queue_port,
                                     "--tablePort", table_port) do
      sleep 2

      assert_match "Azurite Blob service is starting", (testpath/"log.txt").read
      assert_path_exists testpath/"log.txt"

      assert_match "InvalidQueryParameterValue", shell_output("curl --silent http://127.0.0.1:#{blob_port} 2>&1")
      shell_output("curl --silent http://127.0.0.1:#{queue_port} 2>&1")
      shell_output("curl --silent http://127.0.0.1:#{table_port} 2>&1")
    end
  end
end
