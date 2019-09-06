class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/19.07/MediaInfo_CLI_19.07_GNU_FromSource.tar.bz2"
  version "19.07"
  sha256 "8feeec8f6eaf38ac6cda64f25fb10cca554ed15b8fcf9e01e38a2085605dad80"

  bottle do
    cellar :any
    sha256 "4af9358e850acf780f4f1c9b4d8cb3186623c43ca6255168a909b65d30bf17ad" => :mojave
    sha256 "9b1225a74dd9819579db72ce1408c43b2de2f2ee912bd9f6c421360c85366a52" => :high_sierra
    sha256 "6aaa8ef6356da8872bfc596477e7da669b7f69481c7c182a2fa55bf3a579c9f3" => :sierra
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
