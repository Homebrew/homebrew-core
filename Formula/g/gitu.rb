class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "db46dd349e60c82b325eadcaa64e72630fba94ce230e87aa1aaac26fa077cdba"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a714e634122106fdf488d935c4145e9510d48bb828163ea49f97488dabbfb9f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "883b9af2cab460fc56626946d9a45c023f51d9b179e6033cf736bbb7fa8b5775"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1922847485cfa5c2c1397fd70cf8827e699d06087ce7312d4e42801bab0e1a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a33bada2f75150156d987e0b7d2fe4669d82d225faf4540df400cb62604e8ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3094d399525cf7dd23a060716d7df6f561b89ff8a4c3fc5a4b0b1e112b548a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aadffc8b3fe4bc9d4f4f01589e1451b8a666cd4bf69492249a790b1080ba9126"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output("#{bin}/gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end
