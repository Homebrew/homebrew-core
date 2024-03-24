class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.6+release.autotools.tar.gz"
  version "0.7.6"
  sha256 "162d72a306bb2e114c24fa25267d0d0a0ac16f39fd95a5c0dfc75a666ee5e4f5"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0115ae0c8796f4259c337ceaa1e7e2971a1e94ff5c81ab3f85969374d884f56"
    sha256 cellar: :any,                 arm64_ventura:  "a381bddf7906b96e6413d7041c98c4fb1d8372fb46a4d4b1e45f2d03d0269eec"
    sha256 cellar: :any,                 arm64_monterey: "ae78319f7e46e9c887d7d274e835065b255197d8634f74bf797837b70e919348"
    sha256 cellar: :any,                 sonoma:         "77056c734028d7e07024c2e358c9a724a5ce1baa64c733f7d1ac36df7d85f107"
    sha256 cellar: :any,                 ventura:        "3578e8fa2f1e9d1b38ecb0adc70432740a9b12d4e5f018a10789bdd972a54f46"
    sha256 cellar: :any,                 monterey:       "252ba5426be3d02a3e59a598a0f94593028db4f42379ebb760cf846e18d5d755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5c0e52009df8c929ec72505460772e40cc392eb4a43c825e4f804f5d460e5db"
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
