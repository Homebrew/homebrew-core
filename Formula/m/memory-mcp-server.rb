class MemoryMcpServer < Formula
  desc "Model Context Protocol server providing knowledge graph management capabilities"
  homepage "https://github.com/okooo5km/memory-mcp-server"
  url "https://github.com/okooo5km/memory-mcp-server/releases/download/v0.1.1/memory-mcp-server-0.1.1.universal_sonoma.tar.gz"
  sha256 "e33b8ab76fab6d26cac5e56a66d191decaf90fb92bdc27a2e91e1df122b39e07"
  license "MIT"

  bottle do
    sha256 arm64_sonoma: "e33b8ab76fab6d26cac5e56a66d191decaf90fb92bdc27a2e91e1df122b39e07"
    sha256 sonoma:       "e33b8ab76fab6d26cac5e56a66d191decaf90fb92bdc27a2e91e1df122b39e07"
  end

  depends_on :macos
  depends_on macos: :sonoma

  on_macos do
    on_sonoma :or_newer do
      def pour_bottle?
        true
      end
    end
  end

  def install
    bin.install "memory-mcp-server"
  end

  test do
    assert_match "memory-mcp-server version 0.1.1", shell_output("#{bin}/memory-mcp-server -v")
  end
end
