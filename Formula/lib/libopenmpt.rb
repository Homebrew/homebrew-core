class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.8.10+release.autotools.tar.gz"
  version "0.8.10"
  sha256 "976d259288c40cd285771f77d09eff3d02514511d5677ecfcfb53be5013317e2"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d2951c4cbe6442f6e58601460bbfd0e66f6a9a862c05434d7ca4e34d0b5208b2"
    sha256 cellar: :any, arm64_tahoe:       "a266d370b8b13184d227606da83e96d0c8e0671d3148822c5e280905a5e99d07"
    sha256 cellar: :any, arm64_sequoia:     "d09b0484f592ab0f2290b046dd7791cdc7958018e04ef286b856e8218e47edee"
    sha256 cellar: :any, arm64_linux:       "48719958b8b7e63405daebc97eaa831e2fab636767415c7b74b37ea2423e87c8"
    sha256 cellar: :any, x86_64_linux:      "00f08295d696b1de1bc90e29fdb934f75e5841f0a989e709b430c4d68f1c3054"
  end

  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  on_linux do
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  resource "homebrew-mystique.s3m", :test do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
