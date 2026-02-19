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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64388c3368efe673234fd5d7990c0f791df04fb1622c27f347332e56d3fc44ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e09d876529de57fa2b1a1ad7409e5247e800d47bc0d78b1e4b8ed8ee9191c8be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32b130a827813abb0f08be6192ca91c886935172279932f0f3b7906ac4e846a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce176d1a39ea1d4ef3807e937f6ade079256b6925db43c1474f0a3cedf3c917c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22da060bca2c2eb0dacadf143c8152c9722b1b2f15418483e51c8f48390fa85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa55d22946aab558581f444b82e9695ce06f3fe7e550da005447ccf1de942078"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
