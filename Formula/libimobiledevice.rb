class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "https://www.libimobiledevice.org/"
  url "https://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2"
  sha256 "786b0de0875053bf61b5531a86ae8119e320edab724fc62fe2150cc931f11037"
  revision 3

  bottle do
    cellar :any
    sha256 "08f492ac669856b6c8b24b47837e1ad771d028dd86017c1fa2fd22a64e681183" => :mojave
    sha256 "99f3f03c16a4a3818ade87ca533a54d411613b9f07e8c61bf49f157771bddc2f" => :high_sierra
    sha256 "430aae9daa52ff2a477d691c338bb7745ca62e4a889027f116112af63613b1c8" => :sierra
    sha256 "64640027ae8fd012ff75d25c2a6befcc10e688aabcfcb885edef03d24e0e7e23" => :el_capitan
  end

  head do
    url "https://git.libimobiledevice.org/libimobiledevice.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "libxml2"
  end

  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libtasn1"
  depends_on "openssl" # no OpenSSL 1.1 support
  depends_on "usbmuxd"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          # As long as libplist builds without Cython
                          # bindings, libimobiledevice must as well.
                          "--without-cython",
                          "--enable-debug-code"
    system "make", "install"
  end

  test do
    system "#{bin}/idevicedate", "--help"
  end
end
