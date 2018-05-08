class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/18.05/MediaInfo_CLI_18.05_GNU_FromSource.tar.bz2"
  version "18.05"
  sha256 "aaa70120ce7100f37c41c545d1a26d946e614dc858e6bd5ea91fa2e10b00f696"

  bottle do
    cellar :any
    sha256 "be8dd1c8bfb6e0f7e9a25ab944a49a8ba833a5977a4748da2e2c00ffcc8e7a12" => :high_sierra
    sha256 "eb7e5952204d280fc5edc5851a75530d5ce1e7d59c6ac5fd68ed69c55e623fdd" => :sierra
    sha256 "e39b77f8806962c4244895252d3a6214de9e3eaae5bb7796f23069195824ba09" => :el_capitan
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
