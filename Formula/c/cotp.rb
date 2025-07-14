class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://github.com/replydev/cotp/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "4a712b2f01575cecad02d44ee49f941a70f18d9548ae163ff938885457ccc71a"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "230b300e4658e75da28ecb2480f4fd59b3b85d699c1ba077427debd9da5fcfec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c977333f265f5848cb654b3821f02258580650d6b76e88501dd3b09bd59648f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bd2020316409df77c914e2806965912812cddd88a91070b45e240024cb09bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "35b2c18c608b59e4a0ba906b65ab41d03ede7f0fdb0d6c33f44349d57598090c"
    sha256 cellar: :any_skip_relocation, ventura:       "be168173afc155dd3d98a93017dbfc6ea40348a744ba109011a270a3eef71da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beb0855b0b7fe94fd5c8076a9e29ebc74a291f50b056dc48185b7b6f1aabb0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "704d9921263cb986afd5fdeb101ca1fa2781152be5d3103d910e3139e11c35b1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Proper test needs password input, so use error message for executable check
    assert_match <<~EOS, shell_output("#{bin}/cotp edit 2>&1", 2)
      error: the following required arguments were not provided:
        --index <INDEX>
    EOS

    assert_match version.to_s, shell_output("#{bin}/cotp --version")
  end
end
