class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/20.09/MediaInfo_CLI_20.09_GNU_FromSource.tar.bz2"
  sha256 "a252aa61dc1f4caeb9dc76d82292cadc993fb112a402dffd9e442e7fdf76e88e"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/download/binary/mediainfo/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "b46a602b99c9c288fc9877d2cc1b058126e89e216122fc74a038bd774476742d" => :big_sur
    sha256 "112ef7ebfe369ee8d56c91beecbea805750f82a71c5bb3db858d80e9105219fc" => :arm64_big_sur
    sha256 "1474fc89021c1bd0a097034aea8aef77678f02b8e22c5a5fdf0cb7d1f5685acb" => :catalina
    sha256 "dec0e6371975e56bc28b50d02fc965e37424f920e8a7cf99fb173bb2d707d2be" => :mojave
    sha256 "01f4906a106702475bb330c4e51560da1ef0a4da42fe0531289bdff6960104d5" => :high_sierra
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
