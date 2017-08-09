class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.98/MediaInfo_CLI_0.7.98_GNU_FromSource.tar.bz2"
  version "0.7.98"
  sha256 "d194ff6fb32880e5f0e3c11b2d9139c65f647b8049d57258258870e9f2b316e4"

  bottle do
    cellar :any
    sha256 "39f1004281cd63be5c93d71e00846d46f1996c10adad8ea3714e26b2cb37483d" => :sierra
    sha256 "caaa25dd252801f0aa1a14926625fb20bea751ccaced9d6a0b700bfb427faf52" => :el_capitan
    sha256 "afbc58c6d01aa35cca42ce7d103836c495cfa621ef093cb2c048125a789a6167" => :yosemite
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
