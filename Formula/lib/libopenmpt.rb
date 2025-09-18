class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.8.3+release.autotools.tar.gz"
  version "0.8.3"
  sha256 "25d486a4da9728819274ed0959fd79a1c6358954710d54c14047c6457c8ca8ac"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56d1ef741550b0b891c8ce18f888c459779b29d6774290f6f6deaddb4eb1a887"
    sha256 cellar: :any,                 arm64_sequoia: "12494e094046cb3920fa10ce9f7643592db0e945f96ada9b793bb2b7b77a9a38"
    sha256 cellar: :any,                 arm64_sonoma:  "5a92b1ef7e83211e0e7b52b87a6000f46fcfe75a75643d3060559f882f1fb7d4"
    sha256 cellar: :any,                 arm64_ventura: "3f9488905999cf2fa08279abcb663a1808f6917867b5d023928f5d74ed982f89"
    sha256 cellar: :any,                 sonoma:        "f6fa5f179d2d7f379188797e5f951ebdea4bcee9d02cbd6cd4afdadba456b89e"
    sha256 cellar: :any,                 ventura:       "4be3b67cc4cc13648514653011a68579658bfdcee5bd658d892cdc5173fb56d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31e7af6b5d5cf7ccb90b47594f8ee837d2ff7ee418b1790106cd60d00eb72489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51dc91600020dcf292f5cfda15dc87caa27cfd1a872c8ed8410bfea310fb85f1"
  end

  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-vorbisfile",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-mystique.s3m" do
      url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
      sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
    end

    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
