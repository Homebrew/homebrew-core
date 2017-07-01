class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.97/MediaInfo_CLI_0.7.97_GNU_FromSource.tar.bz2"
  version "0.7.97"
  sha256 "ea1bea0ea23030128df2ca72aa94680662f37631dd087dc961eb076e73ef8125"

  bottle do
    cellar :any
    sha256 "0659a0144e2d1f515a8076d0a213d94c7a1855511988bbd2a71a90ef5d6d1280" => :sierra
    sha256 "8ac3d22dfeaafa5c89990d734bdfa431cc697c1c4f9c1c50154ba26b2d26605c" => :el_capitan
    sha256 "987b6e7c520071d878269ac366fd7da5b09e1761d1c40e483704a4e09846b227" => :yosemite
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
