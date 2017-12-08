class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.5.0/heimdal-7.5.0.tar.gz"
  sha256 "c5a2a0030fcc728022fa2332bad85569084d1c3b9a59587b7ebe141b0532acad"

  bottle do
    sha256 "7b29632e947e41264d612762aae915f25e9e522895ecb5b63cd48cf6047e0dda" => :high_sierra
    sha256 "a2100430e4500cb7d1419353e8ea8ba1ea4f766fcc36ff04db70275895a9d2c9" => :sierra
    sha256 "b837af6df80584d06e0d9f902f90e44c2c6a765e400d9e14dd64b18baf402052" => :el_capitan
    sha256 "bb674ef52b4f4bd84478efb7258b85da4c207ad40843acdb20447571421f4c40" => :yosemite
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
