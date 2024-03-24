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
    sha256 cellar: :any,                 arm64_sonoma:   "0f4b442cebfad00948914e0beb7652ccf29b91d4f69688f400dd7d94dc896f7e"
    sha256 cellar: :any,                 arm64_ventura:  "b8045d9b79887d093b574be1291678b9d02d1e0b549118101f9228809948bbbd"
    sha256 cellar: :any,                 arm64_monterey: "ccfa8f38e46118fc35816671c2f3000a52d427521a25f3e154fbc9a3d977c3b6"
    sha256 cellar: :any,                 sonoma:         "a4de66073601aeb99187dc1d8ebbbda74b5c875ea1cc8ea115806d8cc34d7876"
    sha256 cellar: :any,                 ventura:        "fc12b227827f96677dbfc78c9a5afdee526eedaa61b4ac885463c490b97099df"
    sha256 cellar: :any,                 monterey:       "584f270657299794cea1d58255f358e08cdb8cbc8b8a87baa761daef32a0fd3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef80e60f8d531a63681c1fefb342a0ac65638908c2b560d0a62a3d717594d12b"
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
