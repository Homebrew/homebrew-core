class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Findomain/findomain/archive/4.1.0.tar.gz"
  sha256 "d0a71b54c51e5ad6104bf71d0c4a53c255a81ca334c314b711227a765292dddf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "927d1c19cfec0697bd0237044ae33e62c9d9a968bfc593508aac3ecd02d9b9a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb90cda08e18d47f040e3c866fd2a465e713efb0f4b527894af99ef0c37ec1f3"
    sha256 cellar: :any_skip_relocation, catalina:      "f0ca1f37371167d16c82d719fdff35546d8388799c88b1f324583f8accbde03c"
    sha256 cellar: :any_skip_relocation, mojave:        "9b99d238a617b04059485419304412a8bca562e445de44ba8ef6aa8739707326"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
