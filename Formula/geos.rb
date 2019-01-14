class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.7.1.tar.bz2"
  sha256 "0006c7b49eaed016b9c5c6f872417a7d7dc022e069ddd683335793d905a8228c"
  revision 1

  bottle do
    cellar :any
    sha256 "3f5a7633f56fd1368d9c28b32965ac6c88301cca1b80a3fbcbe371db2402621d" => :mojave
    sha256 "2150938fdf54ba352b350677bf10e71edf05fabc5e07ab96a627f141ede216a0" => :high_sierra
    sha256 "2624adf8445ba1efa41f302c6b3c4a1bbc74dc898fcf3fc98914f0748747bd06" => :sierra
  end

  depends_on "swig" => :build
  depends_on "python"

  def install
    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python3-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-python",
                          "PYTHON=#{Formula["python"].opt_bin}/python3"
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
