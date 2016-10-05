class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.89/MediaInfo_CLI_0.7.89_GNU_FromSource.tar.bz2"
  version "0.7.89"
  sha256 "465cfedb12708cca5763a7db56b6218ad7835e874bdae45d2f835073457caeee"

  bottle do
    cellar :any
    sha256 "1c1a441c0d6613d535676cad75f8d175c360aceaf2551dd5b4afad3e0c92a733" => :sierra
    sha256 "11745a0c961a78cc7f02d3386c98c0fd9401819f81bf8bb1b6ad45f666c250a8" => :el_capitan
    sha256 "e222b1523d9eed39edaaceb84d816f77d723b58c21b09c8f6d44bbc1f7fbd9e3" => :yosemite
  end

  depends_on "pkg-config" => :build
  # fails to build against Leopard's older libcurl
  depends_on "curl" if MacOS.version < :snow_leopard

  def install
    cd "ZenLib/Project/GNU/Library" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
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
