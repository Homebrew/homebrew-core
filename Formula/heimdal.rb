class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://www.h5l.org/dist/src/heimdal-1.6rc2.tar.gz"
  sha256 "8fe19e0f12ff0d0c2f20a6cf56727deaabd89db9c197288022fb489e103b730d"
  revision 1

  keg_only :provided_by_osx

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end
end
