class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.5.0.orig.tar.xz"
  sha256 "2a63118f8c91faa2102e6381ae498e7fa83b2bdf667963e0f7dbae2a23b827dd"
  license "LGPL-2.1"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "118b191fb44a9620d8c0c354f8ac922792d3e75d54bc39ca1510be016c3a2d92" => :big_sur
    sha256 "31ff556939a9d57214d7ad44c1d842d23dfdb3908994a286681df2a8c1dbd46d" => :arm64_big_sur
    sha256 "7188c8c30f91805fb9a57fdb2724372e3c322df32cf429b9aa83947a1fda06be" => :catalina
    sha256 "976ba22be91927b7b3ef72c657b642b3b2c29c78d9c8ae2ce427ffd10fdca830" => :mojave
    sha256 "eae28b543407ce32653a9c6611f89c6d7fafee8adbd84e76f4785ec962d5bcd0" => :high_sierra
  end

  depends_on "gettext" => :build
  depends_on "python@3.9" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("grep domains #{share}/pkgconfig/iso-codes.pc")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
