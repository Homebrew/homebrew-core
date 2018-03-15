class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  url "https://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2"
  sha256 "786b0de0875053bf61b5531a86ae8119e320edab724fc62fe2150cc931f11037"
  revision 2

  bottle do
    cellar :any
    sha256 "5e43809c7bcc2abc2a6d9ea8a3b65d9a0b24e6c149288d27358e8a8fabcd8b38" => :high_sierra
    sha256 "7440711e4b0b3c52a1b543b770b18de751a362086419ded9310f55fe104f546f" => :sierra
    sha256 "03715926236f2e946de067f87bde7876335b1ffe8267747b54e60e729dcd3548" => :el_capitan
    sha256 "5b97af6571b290a889d4627fdc6eb63a6eaf83adeda40f4e9aaca765010bd017" => :yosemite
  end

  head do
    url "https://git.libimobiledevice.org/libimobiledevice.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "libxml2"
  end

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "libplist"
  depends_on "usbmuxd"
  depends_on "openssl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          # As long as libplist builds without Cython
                          # bindings, libimobiledevice must as well.
                          "--without-cython"
    system "make", "install"
  end

  test do
    system "#{bin}/idevicedate", "--help"
  end
end
