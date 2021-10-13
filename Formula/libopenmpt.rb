class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.12+release.autotools.tar.gz"
  version "0.5.12"
  sha256 "892aea7a599b5d21842bebf463b5aafdad5711be7008dd84401920c6234820af"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8f93354744d284106c687ebcfb10817ab6d438144e27657e30e1b35ea604545b"
    sha256 cellar: :any,                 big_sur:       "5e05bb357744262501719e7885ab6f0873c80780dd160e12afeef36dffbbfcdc"
    sha256 cellar: :any,                 catalina:      "114b014a3021eaeeaab8c3e42db10f05972fade6b7e6a3b67d3575d1b3e1de03"
    sha256 cellar: :any,                 mojave:        "def4489337dc2369520a07306fac2627fb1a1fa46f88b655049dcb0d79dbd0f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1741494f91a12c0d26da1c20623f76ae493bc34448f4d9f0b272d0cc68859018"
  end

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" # for C++17
    depends_on "pulseaudio"
  end

  fails_with gcc: "5"

  resource "mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-vorbisfile"

    system "make"
    system "make", "install"
  end

  test do
    resource("mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
