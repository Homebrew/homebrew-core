class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/3.3/hamlib-3.3.tar.gz"
  sha256 "c90b53949c767f049733b442cd6e0a48648b55d99d4df5ef3f852d985f45e880"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e4e6a62579bb7dd47bc73a528aca90d1ef1e58cacedff63b7c361fa59e6810cd" => :catalina
    sha256 "2c1a41c0f49147e27a43f4df51ec259faff810d5d186c7043b644ae70a641b78" => :mojave
    sha256 "b212b498824c486ff9805eb4e313a0ab709442b73c2267168b3ac36b593ecea9" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

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
