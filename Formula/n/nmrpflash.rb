class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.25.tar.gz"
  sha256 "729b2890620febda4748b502f652f17b9343c9bdd80c1608656c2767e86f6b04"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58b638caa14a68dc8396e69df7a8774d5f32afa8ff94259842b58ea2bb835b3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ee2c4b9e0928711561e54d90a74ba22729ea004ee8a680fadfb03ceaf4d44b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1170fff7a61b522585f0de7fed71eee17acdada99eddcb876de3f1209fa72aa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5118548149535c43336bc6c42a6907ac529bfa1387b47621cb3a14655def1556"
    sha256 cellar: :any_skip_relocation, ventura:       "55c02b5c5686dc38ae336ffd865874146fdf315a30381f962d8929ebca04bf87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48c4d4e7e9cbb093ce3f552eef69e1ad5adc0e8b84279e347f03489c138937ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02204c8781d87e4c00790807d5367f6826f8420984af35eccaa606f8c1217d90"
  end

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libnl"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    system bin/"nmrpflash", "-L"
  end
end
