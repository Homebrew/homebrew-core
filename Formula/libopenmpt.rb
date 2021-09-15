class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.11+release.autotools.tar.gz"
  version "0.5.11"
  sha256 "4469e095948d976cff4d7eb1936a27e9947624e49b160c29fcb246911ba5a4b0"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "99c98c076e1c257c742042e7445bf0c440cf39af98dfcc86602303e1566cb700"
    sha256 cellar: :any,                 big_sur:       "c8162bdb274a343204e64ed72484d90e989d183d9bdfdb80b9bc26b936f1a7d0"
    sha256 cellar: :any,                 catalina:      "a4bf21dfb4587f17a820e9046a52f03da174310e8af9311b6b5ee5fdec492737"
    sha256 cellar: :any,                 mojave:        "0877f7fe6b8593a88ac32e378a89f445759305fe69f7b67ea41c62b132be2835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b708dc422c688ae0334eeabff965ae64a7eb586bfc5764902388c4d148786967"
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
