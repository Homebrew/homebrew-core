class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.90/MediaInfo_CLI_0.7.90_GNU_FromSource.tar.bz2"
  version "0.7.90"
  sha256 "705aaeb73aed4480379b564ef5405ea62459212011fc0634bb2c92fc6a814d50"

  bottle do
    cellar :any
    sha256 "fc5ad90c6735d3525477fd9d3c9f788874519e0c666f03b322b82f49fac1a557" => :sierra
    sha256 "aca2005b7392b60b121df137ceb175d7e3904997bc050711d84e56c779e0879a" => :el_capitan
    sha256 "811382b0e880efa43adba25ca9f5e449122a73878b82317ff654dcbb488773a2" => :yosemite
  end

  depends_on "pkg-config" => :build
  # fails to build against Leopard's older libcurl
  depends_on "curl" if MacOS.version < :snow_leopard

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
