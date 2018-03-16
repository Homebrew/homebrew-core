class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/17.12/MediaInfo_CLI_17.12_GNU_FromSource.tar.bz2"
  version "17.12"
  sha256 "0f23ccc9a78b24104dc387691e1df484ed75350ee77277982cd170cca59750b0"

  bottle do
    cellar :any
    sha256 "a9aaad46e10848fd2378d2ba57e0b053e42ead8528e276c2b80efc18485480df" => :high_sierra
    sha256 "87bc92c96f779880d71a29075af8817014dc1527beadbc4bdc1ba85deb184250" => :sierra
    sha256 "3a78cb54b5971749efaba4da9058611d38504c216f480bd6734d3ad2347540b2" => :el_capitan
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
