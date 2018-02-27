class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.23.10/p11-kit-0.23.10.tar.gz"
  sha256 "f9212a3f225ef543e13fae9945527d66c0cbb67246320035dd94fab2bce5ae43"

  bottle do
    sha256 "e227e652e1455542a34cda89546012ae123f2a09cec18d300ad3333ebc132a26" => :high_sierra
    sha256 "8e43e5d4017d0d3e1f7e33338de3698075bc8df5f5f16de3c259540862a53159" => :sierra
    sha256 "ba09777a464fdf97ff163a59baa2cde816ff98ac1f5c63eeaf716ef192833849" => :el_capitan
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
