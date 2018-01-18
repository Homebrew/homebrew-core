class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.5.0/heimdal-7.5.0.tar.gz"
  sha256 "c5a2a0030fcc728022fa2332bad85569084d1c3b9a59587b7ebe141b0532acad"

  bottle do
    sha256 "5b461217a467645afd1653bbbbb0202e9d39b5748ab7e2d5e1566006497a00bb" => :high_sierra
    sha256 "ffd6e2ac9328dda17a9614aea905f05e879e9184ec94c7bdb62b14c90267547e" => :sierra
    sha256 "011cd9adbc85589034f69ea15a7cd85c60561792f5366e3d977732a9ef076320" => :el_capitan
  end

  keg_only :provided_by_macos

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
