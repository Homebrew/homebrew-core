class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.313.tar.gz"
  sha256 "898516523b4132053effc40aca4ef46a3612bca160a5ba2f02fe206d47eae200"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4b1424d4d6fdb98e827b061e9bc46c114af44105483773eee10b28ac06cfd7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4b1424d4d6fdb98e827b061e9bc46c114af44105483773eee10b28ac06cfd7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4b1424d4d6fdb98e827b061e9bc46c114af44105483773eee10b28ac06cfd7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1184a2c852aec009a3b38401b7c009febae29ecf0c8bdfa786cc147784420c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f60be3988f1cfded4ea963f5ba4c6841662f78cca02ca5bca37487d43ea359b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
