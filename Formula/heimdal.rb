class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://www.h5l.org/dist/src/heimdal-7.1.0.tar.gz"
  sha256 "cee58ab3a4ce79f243a3e73f465dac19fe2b93ef1c5ff244d6f1d689fedbde2d"

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
