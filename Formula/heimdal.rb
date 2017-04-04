class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://www.h5l.org/dist/src/heimdal-7.1.0.tar.gz"
  sha256 "cee58ab3a4ce79f243a3e73f465dac19fe2b93ef1c5ff244d6f1d689fedbde2d"

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
