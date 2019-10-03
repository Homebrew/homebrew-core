class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.18.1/p11-kit-0.23.18.1.tar.gz"
  sha256 "34c3bd8c0050dd7c4e6228aecf0f168de0a1b34562ddbf74a1c70904c2523c6f"

  bottle do
    sha256 "a96c1ed51ba62da76ee2e54203670927ecbfc8778b5a1ffaf1593727b48a86b5" => :catalina
    sha256 "f199520dd64b5a625c5017831de90f4c92b9ec9209623abae292f817d529e0b1" => :mojave
    sha256 "05548f0cce3d85d4cbff9f98559ea0b14977dc5803c3f2fa6aa1aa7eea306c1e" => :high_sierra
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-trust-module",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-module-config=#{etc}/pkcs11/modules",
                          "--without-libtasn1"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
