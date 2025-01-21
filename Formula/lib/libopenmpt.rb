class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.13+release.autotools.tar.gz"
  version "0.7.13"
  sha256 "dcd7cde4f9c498eb496c4556e1c1b81353e2a74747e8270a42565117ea42e1f1"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "de53708b6627a52650fff543f027194c113a948ed6e548027b9430ef8a5d522b"
    sha256 cellar: :any,                 arm64_sonoma:  "209c8b3da72dec59f33451bb89a6b8370e8fcec9feab1e920ea1cc35db3ac9d4"
    sha256 cellar: :any,                 arm64_ventura: "7a14897fb13fbe42a3067e7cada494fb614ee1f1ada58b81167e63e056424d6d"
    sha256 cellar: :any,                 sonoma:        "47996528e1e90e053f1b569b2096d01543090083de79548c7951c3b415a96e34"
    sha256 cellar: :any,                 ventura:       "2e643f6611d1683d84feccc50ec07c299e980a2277bd5238e4d53d5a7c8efc15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a561021a4c0e7da15ac380cbe3cc9ea6e428e98cd8d8f8ba03bb3fc4db0851b"
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

  resource "homebrew-mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-vorbisfile",
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
