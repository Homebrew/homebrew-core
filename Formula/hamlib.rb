class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.0/hamlib-4.0.tar.gz"
  sha256 "1fa24d4a8397b29a29f39be49c9042884d524b7a584ea8852bd770bd658d66f2"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d02431f4e66de4b0c9fadafb49d9b8f262559de56579f09f16341e97bd64eed8" => :big_sur
    sha256 "1969a57464d0c93b758c38a62b097e12ea18fb766085ea2190bfbb7483d224c8" => :arm64_big_sur
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
