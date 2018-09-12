class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/18.08.1/MediaInfo_CLI_18.08.1_GNU_FromSource.tar.bz2"
  version "18.08.1"
  sha256 "0b9559575f115910d43918c9927e3690ac18741c0ccba3dc7cda05c517cb562b"

  bottle do
    cellar :any
    sha256 "9f1593ba26525effbb4066866a8a51b38760dd734fbc8801f68d2e27ad5863cf" => :mojave
    sha256 "4c7a5f9212f15568de3784dd849215706c4b234da5692b4a707ca3a4b2c9d2cc" => :high_sierra
    sha256 "f9ea3ec8fd7df7d67cb23a25dedb4f40f43c892a76200b2354c6f6845270700c" => :sierra
    sha256 "54656c3440e78f2f3131e6564d950ea218267fa9b6f52a868305e5af65dd9cb8" => :el_capitan
  end

  depends_on "pkg-config" => :build

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
