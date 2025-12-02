class Bulletty < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://bulletty.croci.dev/"
  url "https://github.com/CrociDB/bulletty/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "855aa55629ca0846b1b50a87f2c18c2b7f76d8aa0fbd276187b70a5cb3bc34da"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdea29c4a1f8fd09d587f7793fe0b1b3b607c6291c9b1cc5853eec7567422e8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab7b0c09ae7b565dce5502a991f1d5a4c3a077e35a49b93989b54156ec3c090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5db95bfdfd7319fe0557eba055c2880560fef6853aae895c7efbaa2e280bc07e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dc5da144229cfa3930fd67f96958c8cdb5a1828ee22500dfaa7f15539ae642e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14bc34c659e82ebf1c49b9ef11b06f7951e4344994a4d975007636223ca2658f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79de3a52bbc1b0c1b718b509672be552e2ba1a055f8a10e07b3c20262e99c84e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bulletty --version")
    assert_match "Feeds Registered", shell_output("#{bin}/bulletty list")
  end
end
