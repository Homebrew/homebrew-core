class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.3.0/heimdal-7.3.0.tar.gz"
  sha256 "351df17c11f723681a4eab832e880af4a28693d1ed6996b02671d676dcb3b7b5"

  bottle do
    sha256 "cd8a30410d825da9f6a42d6dc063d6d2b1aea11037db5ed150cac34e7f0a622e" => :sierra
    sha256 "d95f4586629e17fac2066b31c45e9a2882c02af79495fc751a5a11ba336bbc70" => :el_capitan
    sha256 "c78126a7f22cee1cf101c87eedf9e403085b0803037c9434e1898538d8a26fa1" => :yosemite
  end

  keg_only :provided_by_osx

  depends_on "openssl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "-L#{lib}", shell_output("#{bin}/krb5-config --libs")
  end
end
