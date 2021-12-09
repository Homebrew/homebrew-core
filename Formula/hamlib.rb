class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.4/hamlib-4.4.tar.gz"
  sha256 "8bf0107b071f52f08587f38e2dee8a7848de1343435b326f8f66d95e1f8a2487"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "402e4d11f14737861fc0e1b848b3750dd244155148a1e7d209368c52c536f492"
    sha256 cellar: :any,                 arm64_big_sur:  "d2bca238a57f8c159b5056efbc65d4ebe596369e335593462631792ec7152fe4"
    sha256 cellar: :any,                 monterey:       "5de56256bb7d46ca8b2adb77bb47489a53a97d9dfa030f5789f8384d548f0f39"
    sha256 cellar: :any,                 big_sur:        "b048dc58043838aa534d497f1c53fd4ce98a7a430aca691068e828d5b226fbc6"
    sha256 cellar: :any,                 catalina:       "20a4202b385772556054237968690744b850fa3174fe59eaed862489042024bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e10e9c3dd40872ff78d3382aa8040339ddde307ba7cb4253dee08bfd342b8f95"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
