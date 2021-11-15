class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/21.09/MediaInfo_CLI_21.09_GNU_FromSource.tar.bz2"
  sha256 "cced70fc0f23a3e95a5d602099c86547d5b291ff0aef78ea7aaff03908b4d3c5"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d808a90ceb8e9d8a3372df00f86713c44fa63e0e21355fda3f151d0874d8d4eb"
    sha256 cellar: :any,                 arm64_big_sur:  "a867be2d48af32254cf7d789bc1180453caf7966126b2388d80da99a6aaa4f9e"
    sha256 cellar: :any,                 monterey:       "1c27fe68ded8e89d95776eeb2dea6cb326a302e058c0e1f4d0871c0baca17548"
    sha256 cellar: :any,                 big_sur:        "75c84b8b3d32e058bafeee2a086c739e190ee94a92c987bb2928a093eff48e35"
    sha256 cellar: :any,                 catalina:       "5bf600f4122b3922d0935e0c40c1c598a7884d1fb89aead60b27b5c9d2aecd37"
    sha256 cellar: :any,                 mojave:         "207f0ed70033e804e776765b3ba9afd85a50731685441985b9598c225be8c958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "821008db0d750423722c9f694c4b95374ea023844afb6019a09170e2534307ef"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end
