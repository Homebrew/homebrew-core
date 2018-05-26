class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.11/p11-kit-0.23.11.tar.gz"
  sha256 "b243c8daa573f85cb9873352a4c38563812fe3045e960593eb45db7dfdea4a2b"

  bottle do
    sha256 "3fa3ce13ade57872341dd0b5881b3ed8c85e3a6f8c702310e296d3681b5a2747" => :high_sierra
    sha256 "8ac0b7ddec553fcb2df9aae1f94f4905d34af0409c808e01f24f66b9474602a0" => :sierra
    sha256 "003c89e65eb0a3e5e99b1eaf576f2455661623da2993c97a9b3fa37286575b3c" => :el_capitan
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "libffi"
  depends_on "pkg-config" => :build

  def install
    # Fix "error: unknown type name 'locale_t'"
    # Reported 25 May 2018 https://github.com/p11-glue/p11-kit/issues/158
    inreplace %w[common/debug.c common/library.c common/message.c
                 common/test-message.c],
              "#include <locale.h>", "#include <xlocale.h>"

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
