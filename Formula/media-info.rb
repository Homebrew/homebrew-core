class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/19.09/MediaInfo_CLI_19.09_GNU_FromSource.tar.bz2"
  version "19.09"
  sha256 "8b07022943b478ba591eabfb1e6fdc3cdebeb1ec9ffcb4c30751f0a7cd22bf7c"

  bottle do
    cellar :any
    sha256 "fbd91754577bb619927acc08b1ff8571fbf4156e2ad9d55ce0b4cf198b7ca6c5" => :catalina
    sha256 "cf1dcc291f844f0a96fc65e27ebb5e823f9d4323e41e7337c921df80bd7419f4" => :mojave
    sha256 "c0c5548d995ddd10c1bdcdb7cff42cb9993cdf013a7f43fd82748ba0e0303bad" => :high_sierra
    sha256 "cc25e2bc328d7bb23803dd05fce392f7eed7a1c9a7d8bfd48c29eb88a097db08" => :sierra
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
