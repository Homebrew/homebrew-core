class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/18.03.1/MediaInfo_CLI_18.03.1_GNU_FromSource.tar.bz2"
  version "18.03.1"
  sha256 "12d66b59d7cf14ab8d3a1490af66c9140f68a6bcdf8cad5f8f11ee69a19b20b5"

  bottle do
    cellar :any
    sha256 "6905393cf50025850fe7dacd7d2384c64e88800b8f130369499a1fccc176dad1" => :high_sierra
    sha256 "75119d9a20239927ffa6b97a067e41bde291ef14537ba410f9d2a34f00e7fdf9" => :sierra
    sha256 "3e3388365d22f77cc4fee27596c7a0e22849781e1e44f6bcb4abe2e09ed6a4b8" => :el_capitan
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
