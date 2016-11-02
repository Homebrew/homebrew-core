class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.90/MediaInfo_CLI_0.7.90_GNU_FromSource.tar.bz2"
  version "0.7.90"
  sha256 "705aaeb73aed4480379b564ef5405ea62459212011fc0634bb2c92fc6a814d50"

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
