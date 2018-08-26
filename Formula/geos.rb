class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.6.3.tar.bz2"
  sha256 "ab9eaa0a67f7068866ac1e4dbf717b0c49f96254d65e9ce23ed7af1cccbe3e4b"

  bottle do
    cellar :any
    sha256 "add2b7afd025cac3e386e21d6fff17ae916d7209d4e56840820df5716f4a7148" => :mojave
    sha256 "a9fbd9aa0658803ee78f4ff77bbaedb7f12d11242bc9d1000ff89a49a457b63c" => :high_sierra
    sha256 "ed12fb88a6e2deacb538fb4cca1853402f219e5385512af1f08e4200a215531c" => :sierra
    sha256 "911aa73f268cae2ba62873b98f096cdd42f90ef5ab5c527f07f3d11e179eb46b" => :el_capitan
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
