class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "0cc8c195ce35fb83e1a5a4a43e75f1c852ffffe4f1e3eeb3971f2d5128a01691"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "151462499459d8ccc4ba3654f5410fc500f2a8d3d2e9ddc61b15869221195f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9672cd4888a9b34585e58d7cba6fab3de6111436648cb11ceacfe6a4edd14999"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ff037f82d31652ff0dbd05d3f28f02d7dfd1d46b7950e593ad9f6f348543365"
    sha256 cellar: :any_skip_relocation, sonoma:         "9477001e68a57aa6816c37ce8c30fdc27a112a04b3a708263c70c34526b3c676"
    sha256 cellar: :any_skip_relocation, ventura:        "0e21dc32241bbf7af4c485819c22dd72adc658dc1490aef320d407d59ed33b90"
    sha256 cellar: :any_skip_relocation, monterey:       "12bba6b6ab8d5facc742e6e591923e5ec717fd7cbdd90c820f4debc02e7403ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f87f43139b953c18ab269ffdb4cda22b21fe44fbaf4c41836bd642125e3301e9"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output(bin/"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end
