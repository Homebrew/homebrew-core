class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/17.07/MediaConch_CLI_17.07_GNU_FromSource.tar.bz2"
  version "17.07"
  sha256 "c7d026dcff1b4734f62d10541765e78de80c52fc509660ecdc784a80f781e7e9"

  bottle do
    cellar :any
    sha256 "ccd656a1aae8d3bb12f9dfbe45fde69a0c9d345ac00cacc7e9194d82fcba840f" => :sierra
    sha256 "7b94aafd6ffb9f7e21d027f8e07eb303dd4bb43a3cd0f9f63c80391d53adefcb" => :el_capitan
    sha256 "b344b238ce82d76d434a3054568d6d268a4f9696f6095263713c9ef7057085a2" => :yosemite
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
