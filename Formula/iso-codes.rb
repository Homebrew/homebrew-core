class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.3.orig.tar.xz"
  sha256 "643eb83b2d714e8650ed7112706968d057bf5b101ba71c8ef219e20f1737b141"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1d9e330b513c6eb3ecbd853425a933e21087fc17aef2eb37d06c81966014f55" => :mojave
    sha256 "c1d9e330b513c6eb3ecbd853425a933e21087fc17aef2eb37d06c81966014f55" => :high_sierra
    sha256 "da551b41f832e5cdbad7be94dddbae3bc55a48bf8656681413576f07e5aaac6e" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "python" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("grep domains #{share}/pkgconfig/iso-codes.pc")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
