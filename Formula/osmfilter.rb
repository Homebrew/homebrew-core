class Osmfilter < Formula
  desc "Command-line tool to filter OpenStreetMap files for specific tags"
  homepage "https://wiki.openstreetmap.org/wiki/Osmfilter"
  url "https://gitlab.com/osm-c-tools/osmctools.git",
    :tag => "0.8", :revision => "fbf0a0a01624951efd7a7407ee3821fd817acf63"

  head "https://gitlab.com/osm-c-tools/osmctools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "568d4cda4c2da1cd248a4b7f63d7f90d612b92ce77672cfabc52c3de35d87446" => :high_sierra
    sha256 "fd6f2bc2490d732f9a70899505e11d9da0b8a24575ee532fb473b73d016f3b2c" => :sierra
    sha256 "4d81c759c35a68d11432e189ae0ca3204744b5fc8b98ec2ccf7fb1ca07b000bf" => :el_capitan
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  resource "pbf" do
    url "http://archive.osm-hr.org/albania/20120930-albania.osm.pbf"
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
