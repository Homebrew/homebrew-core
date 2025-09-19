class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.314.tar.gz"
  sha256 "8b8b47a90521a9a5544b3f7414b4b296b5f5a00d064121bd5856c29b1f62eac4"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a297fdeffb2c89078ae4dacf618629096344476ffbb09984944ae215b0b1ef3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a297fdeffb2c89078ae4dacf618629096344476ffbb09984944ae215b0b1ef3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a297fdeffb2c89078ae4dacf618629096344476ffbb09984944ae215b0b1ef3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1db07703c686a838c66849198007e7299f29c16f2e1a423ec7aeda2a92169d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0be7e56c33fe258dd99303d4adcfeb6dbb987dec1d370c67aaec0f4c783f9843"
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
