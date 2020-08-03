class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.21.tar.gz"
  sha256 "6295bc183d8a9694f2546100909fb0b1943f0acc55c9743937f435f17d47ddbc"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce90a45b81d9339bcc51c84905d58b406b489d0a52ab5c1ad250ae75822ec7c2" => :catalina
    sha256 "38f782313236f406e78c8cfd8c65145da3bfce221580b1c5f5d26cdc1655d23c" => :mojave
    sha256 "76cf4ff0475218d4d51e4fbbf1a8ee36df7b5e64c8d9cde524083b35b5e4e4a3" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
