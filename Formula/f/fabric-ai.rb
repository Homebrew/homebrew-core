class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.203.tar.gz"
  sha256 "78a9846014b46544feec9014dd455ea8c702b4b7e060a29bca744585c40ccd36"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "689de7e45e48e45c116b0b18f1cec19f01a8624675251da65220870f9d63bf32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "689de7e45e48e45c116b0b18f1cec19f01a8624675251da65220870f9d63bf32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "689de7e45e48e45c116b0b18f1cec19f01a8624675251da65220870f9d63bf32"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c56ef00c30dab63a2c3be13904c9bce95d0f146cdcd674b97954de7c2cd9d38"
    sha256 cellar: :any_skip_relocation, ventura:       "4c56ef00c30dab63a2c3be13904c9bce95d0f146cdcd674b97954de7c2cd9d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4efdc9ecf91835b126c88064a3a97a38a5c74426b91b1cf682ebda8ec30f6ce8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
