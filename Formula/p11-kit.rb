class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"

  stable do
    url "https://p11-glue.freedesktop.org/releases/p11-kit-0.22.1.tar.gz"
    sha256 "ef3a339fcf6aa0e32c8c23f79ba7191e57312be2bda8b24e6d121c2670539a5c"
  end

  bottle do
    sha256 "2fc8da74d14aca3af0dd9b76e160cf8842b44223814b7c2b94e135c4f1df603f" => :sierra
    sha256 "2c141f369e6cdc5d3d11e2e2002e346c0fc18168671125f129b411f5c9e9f185" => :el_capitan
    sha256 "2e79ba610021a8f93be9a40656097b0ee7bde232d16230d44f5e038d98beb1ac" => :yosemite
  end

  devel do
    url "https://p11-glue.freedesktop.org/releases/p11-kit-0.23.2.tar.gz"
    sha256 "ba726ea8303c97467a33fca50ee79b7b35212964be808ecf9b145e9042fdfaf0"
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

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
