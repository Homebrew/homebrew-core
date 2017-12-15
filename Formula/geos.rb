class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "http://download.osgeo.org/geos/geos-3.6.2.tar.bz2"
  sha256 "045a13df84d605a866602f6020fc6cbf8bf4c42fb50de237a08926e1d7d7652a"

  bottle do
    cellar :any
    sha256 "bd35ebbcc9d142b0ee4d1f1837520cd0e195e13e3ea1804c5cfd1cc99d660b9b" => :high_sierra
    sha256 "a435dcf855256300793f56c3d0af6597f39958bde52adc29d07736f897b40c1b" => :sierra
    sha256 "8fa4f17ee4b0f8c52bdb155f4264043f12245858e413975cfea4355d569db207" => :el_capitan
    sha256 "5966c5ecea54189c67a3ffb5856176f4bb070ca72b3c3628ad7b76fb67e35de8" => :yosemite
  end

  option "without-python", "Do not build the Python extension"
  option "with-ruby", "Build the ruby extension"

  depends_on "swig" => :build if build.with?("python") || build.with?("ruby")

  def install
    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]

    args << "--enable-python" if build.with?("python")
    args << "--enable-ruby" if build.with?("ruby")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
