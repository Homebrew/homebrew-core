class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/17.05/MediaConch_CLI_17.05_GNU_FromSource.tar.bz2"
  version "17.05"
  sha256 "1c8fb8b38f170d9f5d009550068a54986c92eb3e93d9b6b72f60fbd4cef68a66"

  bottle do
    cellar :any
    sha256 "bf4ea72cb8bb7fed78449d110d0c646ab908242175ad352dc73a15ac276728ef" => :sierra
    sha256 "daebcfe58ced098b2199ef1a49cebc74f501fd1587780c3c04f46f126470e2ce" => :el_capitan
    sha256 "e05eeb856d5097b45543364a22241dc31efb1f704918e4fda47b299d574f5c30" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-shared",
              "--enable-static",
              "--prefix=#{prefix}",
              # mediaconch installs libs/headers at the same paths as mediainfo
              "--libdir=#{lib}/mediaconch",
              "--includedir=#{include}/mediaconch"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-static",
              "--enable-shared",
              "--with-libcurl",
              "--prefix=#{prefix}",
              "--libdir=#{lib}/mediaconch",
              "--includedir=#{include}/mediaconch"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaConch/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediaconch", test_fixtures("test.mp3"))
  end
end
