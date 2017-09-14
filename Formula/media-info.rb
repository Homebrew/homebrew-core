class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.99/MediaInfo_CLI_0.7.99_GNU_FromSource.tar.bz2"
  version "0.7.99"
  sha256 "a365ea634b0188566eec25553a50483283a3a600cf69cd6d707e714ee329cb90"
  revision 1

  bottle do
    cellar :any
    sha256 "fe19cd2be4ba9f663ca385406374dcefa31088981ab75dcdd55d7f07d4c9a102" => :sierra
    sha256 "b696c66c1a07ddd58dfa5ab0dec65a60d1325401b56d703bb2a14a54832bacd6" => :el_capitan
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
