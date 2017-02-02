class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.92.1/MediaInfo_CLI_0.7.92.1_GNU_FromSource.tar.bz2"
  version "0.7.92.1"
  sha256 "ff2c0ee44ae2e30e9c5fc271f973741a387b421cbcf3a808a13849282dccc30d"

  bottle do
    cellar :any
    sha256 "6a579cc17da444db938581b28be60aff07ea4d9702955491495e6370de97c7da" => :sierra
    sha256 "909a3a033ae7847517f00b6a884e0c3e832ec4f4855b26e5e0486daa39921f2c" => :el_capitan
    sha256 "953a3869364cbb4f5cb0889916870db3ff4f0ace1b07154e4f2850cbd4f93fea" => :yosemite
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
