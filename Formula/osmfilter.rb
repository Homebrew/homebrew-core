class Osmfilter < Formula
  desc "Command-line tool to filter OpenStreetMap files for specific tags"
  homepage "https://wiki.openstreetmap.org/wiki/Osmfilter"
  url "https://gitlab.com/osm-c-tools/osmctools.git",
    :tag => "0.6", :revision => "7594309ea6f8437a04514f68cc36029cafa951fd"

  head "https://gitlab.com/osm-c-tools/osmctools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9d4bb82465736f6a7be7fb75dddc089474ceca9e468a813067a93fa851a35c4" => :sierra
    sha256 "bfcf14daf9df379499b9c53abf604017b746d7d828d5f235ca9a771191a9d934" => :el_capitan
    sha256 "db7d1ae3b020f0edb9b577701be214abdd347fca463ef6d69dce90913e687691" => :yosemite
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
