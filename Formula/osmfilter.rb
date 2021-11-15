class Osmfilter < Formula
  desc "Command-line tool to filter OpenStreetMap files for specific tags"
  homepage "https://wiki.openstreetmap.org/wiki/Osmfilter"
  url "https://gitlab.com/osm-c-tools/osmctools.git",
      tag:      "0.9",
      revision: "f341f5f237737594c1b024338f0a2fc04fabdff3"
  license "AGPL-3.0"
  head "https://gitlab.com/osm-c-tools/osmctools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daf330073a0fdad514305d1a2af9333705cc946c3bc8e52da4856ae2d0bba094"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b37db3c9ebe77673bbd83fb7d2e6c215760450987df2ded64044eccf6f34d3b"
    sha256 cellar: :any_skip_relocation, monterey:       "806b9fb45a9369e43e4b7f6903cc9a3b98b55c385e7e8828e6aaef556e31b620"
    sha256 cellar: :any_skip_relocation, big_sur:        "5647d8f3a704bd126e2b5f24237febb50989798b425147baf1d1ce1a08fbdaaa"
    sha256 cellar: :any_skip_relocation, catalina:       "5e2b755a970b7432fb076d787cb1777df18861832d0e4d45132fd84e4d7aea20"
    sha256 cellar: :any_skip_relocation, mojave:         "470532603de299b9073f5511b8be798558d430f86ba4f37b330a497ec9fdae48"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b2e2d4190462b0b0e473da4a50ab5e25da007aca21db898d2d359e9e9eb2cde7"
    sha256 cellar: :any_skip_relocation, sierra:         "d7a8285fe18af71d0093b89e9b5613a4fe30ceb4978e07f61ad1974e734d7f50"
    sha256 cellar: :any_skip_relocation, el_capitan:     "6a0fd608e0bc8094f08edb6f86a51b45745506d3ef84e0454ef1498dd77f61b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e3476d7bcb3d9a71fc2d192812526ad3497f17647c9d08daac16b5cbdcfea6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "zlib"

  resource "pbf" do
    url "https://download.gisgraphy.com/openstreetmap/pbf/AD.tar.bz2"
    sha256 "f8decd915758139e8bff2fdae6102efa0dc695b9d1d64cc89a090a91576efda9"
  end

  def install
    system "autoreconf", "-v", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("pbf").stage do
      system bin/"osmconvert", "AD", "-o=test.o5m"
      system bin/"osmfilter", "test.o5m",
        "--drop-relations", "--drop-ways", "--drop-nodes"
    end
  end
end
