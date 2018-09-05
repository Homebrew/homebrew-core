class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/18.08/MediaInfo_CLI_18.08_GNU_FromSource.tar.bz2"
  version "18.08"
  sha256 "8b8aa264dd5b71abe4c3ff4cdfdba52d565034f377248a7089571b48bc25488c"

  bottle do
    cellar :any
    sha256 "f29cdc755bc2ebe425bca3d4359ad4ac19af1e7f76c5f36b1cec1bd0802da56f" => :mojave
    sha256 "93ab72246fe5b2e907164f36c36dc71ee39e99b923eeb0461ff2a97b5f57f601" => :high_sierra
    sha256 "34b97069bb5f854c1ff270920d595d9c2647423519ed785d9942f21df90d71f4" => :sierra
    sha256 "c1ecc1f5da244f2be4c615f95ebe43fe0c351e8db98f697abec022f530ae816f" => :el_capitan
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
