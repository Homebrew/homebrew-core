class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.1+release.autotools.tar.gz"
  version "0.7.1"
  sha256 "bf175d26448bb133f74714f3a8859e7000b93522fb3577559dffc037161910f9"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "df0358e43cfb140109a4c4d9543a187a8b362f895f1d30d64796619680bbb5c2"
    sha256 cellar: :any,                 arm64_monterey: "23051692829ba25cf6073c299ff205cc12cde82e2777d92fe27dbfbf6023dd28"
    sha256 cellar: :any,                 arm64_big_sur:  "2d38b311474c352d8389c689143a8a7bfc2b5a42cde36100af247aea5dcdffb9"
    sha256 cellar: :any,                 ventura:        "25eaa6a13c88983649bff510a8431fc6f75166de620ad5c62f49a46478a2326c"
    sha256 cellar: :any,                 monterey:       "4225b3b75876a1160a9e7e64e5b8224be49338605fc6cf98df5c51b8a3541e08"
    sha256 cellar: :any,                 big_sur:        "f75ebc3ce8e5571d3f6d9c88805c9b8dfb8519aa380f339624882bf8a56d0289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "051844569dcb4f6a2fbaa9dd89ecfd365bdafd7ddff0b6bb1387f1d804c8d380"
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
