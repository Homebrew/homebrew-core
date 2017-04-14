class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.3.0/heimdal-7.3.0.tar.gz"
  sha256 "351df17c11f723681a4eab832e880af4a28693d1ed6996b02671d676dcb3b7b5"

  bottle do
    sha256 "f879c15dc2123fe182d765127f5537a36177778b1eeed20f7f20d40edd299226" => :sierra
    sha256 "ca06957f7d0e6c324d924402e13794697ac28daa6d30e0ce76567b95ed166ec5" => :el_capitan
    sha256 "9df565e540726c32c8e20b42b4d966e299f0ea0649589d8608f9c23eb8a2ae7a" => :yosemite
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
