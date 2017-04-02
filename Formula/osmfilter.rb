class Osmfilter < Formula
  desc "Command-line tool to filter OpenStreetMap files for specific tags"
  homepage "https://wiki.openstreetmap.org/wiki/Osmfilter"
  url "https://gitlab.com/osm-c-tools/osmctools.git",
    :tag => "0.7", :revision => "7ad9cbf748640efe638fde959fe9b1421decf398"

  head "https://gitlab.com/osm-c-tools/osmctools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "695df679621b40bb041d44ed7ee03cb93a4fc65157305be6bb435817605efde8" => :sierra
    sha256 "d97cc8f31c6ebaca1d0c861e847fc75ed8085d24685a1595390a8a9f4e6e6b60" => :el_capitan
    sha256 "c86fe580be660e9de835cb4975413d8fdaa99b17834b5f0c8944b1815f9033d7" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  resource "pbf" do
    url "http://data.osm-hr.org/albania/archive/20120930-albania.osm.pbf"
    sha256 "f907f747e3363020f01e31235212e4376509bfa91b5177aeadccccfe4c97b524"
  end

  def install
    system "autoreconf", "-v", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("pbf").stage do
      system bin/"osmconvert", "20120930-albania.osm.pbf", "-o=test.o5m"
      system bin/"osmfilter", "test.o5m",
        "--drop-relations", "--drop-ways", "--drop-nodes"
    end
  end
end
