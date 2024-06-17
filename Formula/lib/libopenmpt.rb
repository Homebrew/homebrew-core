class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.8+release.autotools.tar.gz"
  version "0.7.8"
  sha256 "87778c8046a226c6cbfb114f4c8e3e27c121b7b3dccce5cb7de45899250274cc"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d6937e4498f93a2a261823d9f80a0b0b0b349ab97255792d3b360a3ed2a67a4"
    sha256 cellar: :any,                 arm64_ventura:  "cc77ddfb029e3a8da4c32e3d268fe387d267668fe5914e3f9fad05f31f779316"
    sha256 cellar: :any,                 arm64_monterey: "2deed484cb038c79a7a70d42f7fba7eca863fb11533326bd686f3eae94c0db1d"
    sha256 cellar: :any,                 sonoma:         "ec9084470c1d3120f4ca31a34e387e2d1f1de40d47e233868b29f72f367dc300"
    sha256 cellar: :any,                 ventura:        "c29c6a8b2b9f0581c9627117f561781e65fb746764ca9a42466240363188e80d"
    sha256 cellar: :any,                 monterey:       "4a76fd9e4f585ddc71326fbf149c1ab4a696126672aa7b0747a9484252c68246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05f64c9589c8bdabaf5205b272e4a7f6d88f30e435eca1b23ac453de6817db3b"
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
