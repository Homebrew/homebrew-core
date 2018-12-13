class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.7.1.tar.bz2"
  sha256 "0006c7b49eaed016b9c5c6f872417a7d7dc022e069ddd683335793d905a8228c"

  bottle do
    cellar :any
    sha256 "69d5adeb06d0089382f28e0bb5a9438057d1d3fa26f172328c1a3bf3a93898eb" => :mojave
    sha256 "921cbe4f3b1e993c4ddac456920aa65de063965c5f83828699b0fc44dabdeb8b" => :high_sierra
    sha256 "a650d30a1dfd64ec32482c4f0362c2ae6add982138267109abb7f232eba460a0" => :sierra
  end

  depends_on "swig" => :build
  depends_on "python@2"

  def install
    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-python"
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
