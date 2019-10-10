class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.8.0.tar.bz2"
  sha256 "99114c3dc95df31757f44d2afde73e61b9f742f0b683fd1894cbbee05dda62d5"

  bottle do
    cellar :any
    sha256 "ff40b1f3533d27f19ddc89ef3836f41f816b67bc492b52b592c49fab66f5f701" => :catalina
    sha256 "ef713f51fa1a2bfada35f3cb002ee36dc4289b59487dc79e46a4ad9ce1236bc5" => :mojave
    sha256 "309f427d5560709649390de757980e37dbedc7851f2f0e02d54fbcd2e2678080" => :high_sierra
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
