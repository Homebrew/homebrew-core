class Libnfc < Formula
  desc "Low level NFC SDK and Programmers API"
  homepage "https://github.com/nfc-tools/libnfc"
  url "https://bintray.com/artifact/download/nfc-tools/sources/libnfc-1.7.1.tar.bz2"
  sha256 "945e74d8e27683f9b8a6f6e529557b305d120df347a960a6a7ead6cb388f4072"

  bottle do
    sha256 "a6f032e306967d4df3177c22363c8c93336ba314216431c5e4ff3380b3823456" => :mojave
    sha256 "6123f4b6cba07ac11b327e378b9b774fca3609cec3e7ef58d6dcb6f6270dc36e" => :high_sierra
    sha256 "18ebd76ab92ace056da2f014b3bbfb872d152ff6dc5d66ae274c7bd67474defa" => :sierra
    sha256 "792064362ef2b224a15190b6fcf97066c7a1d47a3bee13495134aafb067cc11d" => :el_capitan
    sha256 "3f2e7a57fca1f12b4b938c6136036f889562540e6c6a8e5188cd32fabd927a9c" => :yosemite
    sha256 "cabb3f773d92c2cd95af437d6f4c567529229b26b82d568af1c89ec50b674f59" => :mavericks
  end

  head do
    url "https://github.com/nfc-tools/libnfc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "autoreconf", "-vfi" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-serial-autoprobe",
                          "--with-drivers=all"
    system "make", "install"
    (prefix/"etc/nfc/libnfc.conf").write "allow_intrusive_scan=yes"
  end

  test do
    system "#{bin}/nfc-list"
  end
end
