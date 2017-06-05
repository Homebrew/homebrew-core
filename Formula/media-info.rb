class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.96/MediaInfo_CLI_0.7.96_GNU_FromSource.tar.bz2"
  version "0.7.96"
  sha256 "4fb6786a818cb470bd8dbefd2224b9ab6537b827d84ccc532d288d151bda15a2"

  bottle do
    cellar :any
    sha256 "fb1ed23063b8a28542ccc458a031dd93b078d67b073275894977188dbbccb55f" => :sierra
    sha256 "6eb28d8271ff602f8d37f57699a2c3f3f4b59500ec788e94ef3a2e9aceb57ba0" => :el_capitan
    sha256 "f42d62119fdd4c515e850b72ee6a9ef7a844185855c15fed2ec0934efd6c3eef" => :yosemite
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
