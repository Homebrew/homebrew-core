class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "221258deae7204c65a55d3666aaea5fa157312b4196a59abc60ba4d363787c10"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a559dffc87a6e1f99dcda563c601b46fdc92eb9bb5e7eafbb1fce4bb4eae5525"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f0335b6ec968ae1e91d88803adea6b0618f4ff3668040514caddf6e0afc4599"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c564ac8d5501ea3230684b211508c6d201abc7cea48831975a6101827639032"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfbd3ddaa450703cafb04c7095cda74b89d0cc051b80ce862c598cde60c2def6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ce3035179cb094db6ad94da564d235c4359440fc0759d9ecf4c9bc708319a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6693229d486d060cec14dd04bc6f6aed9a81dff7987594ae2461634a50f9ba7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
