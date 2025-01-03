class EnteCli < Formula
  desc "Utility for exporting data from Ente and decrypt the export from Ente Auth"
  homepage "https://github.com/ente-io/ente/tree/main/cli"
  url "https://github.com/ente-io/ente/archive/refs/tags/cli-v0.2.2.tar.gz"
  sha256 "d03754880fe7dfdc422b37e4864c2aa469a2b19c645346de2d2de7fa62b71de3"
  license "AGPL-3.0-only"
  head "https://github.com/ente-io/ente.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"ente"), "main.go"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ente version")
  end
end
