class Chars < Formula
  desc "Command-line tool to display information about unicode characters"
  homepage "https://github.com/antifuchs/chars/"
  url "https://github.com/antifuchs/chars/archive/v0.5.0.tar.gz"
  sha256 "5e2807b32bd75862d8b155fa774db26b649529b62da26a74e817bec5a26e1d7c"
  license "MIT"
  head "https://github.com/antifuchs/chars.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "05b56b9920d19b157a658dabb4b7ec53455c5c874b7f4154a94324610d8e1e7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "15a5fa9f743f43efa5b70fbabc2c26f879d13a304b32a878e6f90ccb5be06c7e"
    sha256 cellar: :any_skip_relocation, catalina:      "4d56b107586689744485ede26f55a0916fe09bfa2e9ec27a250c9da3764f5e42"
    sha256 cellar: :any_skip_relocation, mojave:        "d4bd08669fb838fb8773e4131fd71b972662299ac3c03ff6d83802c6e3d14efc"
    sha256 cellar: :any_skip_relocation, high_sierra:   "2dbec73c5adcc494e0932921f015e69b7b7bd8b1d1b29f7ea08bc56da029c9a0"
  end

  depends_on "rust" => :build

  def install
    cd "chars" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    output = shell_output "#{bin}/chars 1C"
    assert_match "control character", output
    assert_match "FS", output
    assert_match "File Separator", output
  end
end
