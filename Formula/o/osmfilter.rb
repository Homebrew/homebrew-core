class Osmfilter < Formula
  desc "Command-line tool to filter OpenStreetMap files for specific tags"
  homepage "https://wiki.openstreetmap.org/wiki/Osmfilter"
  url "https://gitlab.com/osm-c-tools/osmctools.git",
      tag:      "0.9",
      revision: "f341f5f237737594c1b024338f0a2fc04fabdff3"
  license "AGPL-3.0-only"
  head "https://gitlab.com/osm-c-tools/osmctools.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1c75182ccbe17c6d0bf607a3301436d37728ca4964ea87ec91796b130931460a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1d86b7309f3fbd2c39a78416fe5dc0eac2b08c2ef0795e9c3d83c165ddf122e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "864446d5bf53f85f504188be4f59c5f1fc1b902a647a1666de49bf467fa0fd0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06e67f6d61cc209499475b010c4bfe2375d5e3dcb4429e89485d6b03454322c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daf330073a0fdad514305d1a2af9333705cc946c3bc8e52da4856ae2d0bba094"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b37db3c9ebe77673bbd83fb7d2e6c215760450987df2ded64044eccf6f34d3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9c1a36fc64e71d69d5b8f118f195dba1d0ca2ad34e43db54c5ba157eb46f74a"
    sha256 cellar: :any_skip_relocation, ventura:        "b89f9122cd15cd5da3e03fac3b4a1c33ecd2efb325f98918c7e9e494b3bf130b"
    sha256 cellar: :any_skip_relocation, monterey:       "806b9fb45a9369e43e4b7f6903cc9a3b98b55c385e7e8828e6aaef556e31b620"
    sha256 cellar: :any_skip_relocation, big_sur:        "5647d8f3a704bd126e2b5f24237febb50989798b425147baf1d1ce1a08fbdaaa"
    sha256 cellar: :any_skip_relocation, catalina:       "5e2b755a970b7432fb076d787cb1777df18861832d0e4d45132fd84e4d7aea20"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "71fba6dd634a34968c4296190c8dd7925e6a536c0a289fe97c1bb3abfe75b6ac"
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
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
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
