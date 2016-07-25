class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/16.06/MediaConch_CLI_16.06_GNU_FromSource.tar.bz2"
  version "16.06"
  sha256 "cdd6c9199ed6833ae982a28474cdf41c9d60c4c45794d056935b963077f36196"

  bottle do
    cellar :any
    sha256 "3d9c0e00ef440397e1c9c6a7c4033de492558b71c55fd40f12d63395c2ca89bf" => :el_capitan
    sha256 "794fbd15131e961a1e1238cdaafc5ca434383471bebb0340aa5c52a806b530e6" => :yosemite
    sha256 "24d44de245cd039c0553b7a2ff62c38d769a839b5afd405324ab109e6f6f00a3" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"
  # fails to build against Leopard's older libcurl
  depends_on "curl" if MacOS.version < :snow_leopard

  def install
    cd "ZenLib/Project/GNU/Library" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--prefix=#{prefix}",
              # mediaconch installs libs/headers at the same paths as mediainfo
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
