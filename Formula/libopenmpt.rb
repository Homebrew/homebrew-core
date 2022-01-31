class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.6.1+release.autotools.tar.gz"
  version "0.6.1"
  sha256 "c0bada4bebfc707961111bdb5ff6bbe337f5d71e837e8278f2e362a909eb925b"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eb4748d7f639e41c8ec98446eb5ab65c52b50161a9d1bad2751eb9171f0b591d"
    sha256 cellar: :any,                 arm64_big_sur:  "26aae39f981e16dae7215ba424a6b75aa1dcdb8f5ebcd062dc084da1bdaa4abe"
    sha256 cellar: :any,                 monterey:       "422836c96f7070b8d28b50280ed48cfa81be5140e27cb258d9620b217959ab82"
    sha256 cellar: :any,                 big_sur:        "b324fcdd6ba39e7bfcf1d087f21ab59594ac4e0219c9509ad8279b3b7116756f"
    sha256 cellar: :any,                 catalina:       "9774466a4b1e5f3cee7a9fe792eb434658c98a72c4947fa5dc1b13b803c03459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a47f741ea6a6d2ed527f23095b955d4c3c6b783b50a106e2333aadfcb065c51d"
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
    depends_on "gcc"
    depends_on "pulseaudio"
  end

  fails_with gcc: "5" # needs C++17

  resource "homebrew-mystique.s3m" do
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
    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
