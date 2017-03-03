class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.93/MediaInfo_CLI_0.7.93_GNU_FromSource.tar.bz2"
  version "0.7.93"
  sha256 "047df86b6440410ded0277e5e348f3b96ccd5381ac56a89388aa1b66b0f2dbd5"

  bottle do
    cellar :any
    sha256 "6efc1eded0dac8a04d83f25d8d751f37a790cd237fd30a55a92fe8a3303318b2" => :sierra
    sha256 "58f845224431384ed5c83152c346a431784b0fb38bc773070267a65df3cc4d1d" => :el_capitan
    sha256 "d244fba83ac702131383359c363513d97830da84be545e4088ead04c10f6210d" => :yosemite
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
