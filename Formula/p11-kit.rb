class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"

  stable do
    url "https://p11-glue.freedesktop.org/releases/p11-kit-0.22.1.tar.gz"
    sha256 "ef3a339fcf6aa0e32c8c23f79ba7191e57312be2bda8b24e6d121c2670539a5c"
  end

  bottle do
    sha256 "f8a576f0e0c58aeb43d0973c689d2de5d959febb86082d5f9505661402217946" => :sierra
    sha256 "056f262ed1ed5fa665885f577e5b2463429c255ff2a987c4f2af67f4f23e0a54" => :el_capitan
    sha256 "f82755ab85440b64ec4db85ecaee5c0185ba751a08d693fffd98f8f80c92afb5" => :yosemite
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
