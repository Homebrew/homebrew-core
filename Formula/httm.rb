class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.19.8.tar.gz"
  sha256 "37aece094ce35197f924ec767cd2d3e3bbc9ccf588f1a0be7d94398454a75242"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5010c9f67509a92fbbaa419e02945e16e6d44070d5847ff7ad06178d50ca8851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd318406661ca3be8ac1e75579fb1ed9ba09ab1da6192effd10d3e6132b2389d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ed6004b21d6cbe4747695546d17f6db2ce81d2668b7232e1da11f33282bb6d5"
    sha256 cellar: :any_skip_relocation, ventura:        "573c93ead4a62b112651c6cff35b95ed47bca4e9b241c22ddd29f17dda0784a9"
    sha256 cellar: :any_skip_relocation, monterey:       "a97f375bf1e594aa3bc9c2d98722844e67f2c4f577b7acaa4da2858a4b62fcc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ac72b55fa335e6e2f6c4ea739592c5284bf3de1d93576b1d911ad027b8323fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1e72ed011d0622d9b7be45e9927c72176e32d9d14def243d8b16f01855f5dc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
