class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.7.0.tar.bz2"
  sha256 "4fbf41a792fd74293ab59e0a980e8654cd411a9d45416d66eaa12d53d1393fd7"

  bottle do
    cellar :any
    sha256 "d725d907632e2154e703ba12aece1219cab16f1bb37c0abe99e15ae91014bc19" => :mojave
    sha256 "c2020bfb07cd08dc7165808fd6dbd9618a5fff771c46d35d957156d9d99c981a" => :high_sierra
    sha256 "21d9a9aa5db75f6f99c00fc11d4789db5f3fd136b99ad0ca39c346d885c50f3f" => :sierra
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
