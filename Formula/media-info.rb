class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.91/MediaInfo_CLI_0.7.91_GNU_FromSource.tar.bz2"
  version "0.7.91"
  sha256 "359085606f76749fe1eb5ee391fa62add40c95a9959e0831e2450c71e17d4832"

  bottle do
    cellar :any
    sha256 "a71d90376ade00ba830db6d724552dd0aa828e6283962a4b7793982cd12aede3" => :sierra
    sha256 "29a76b917f8b23a494ba33549d8dcdb81b61a7e6cdc71d5c91148d4a85ccdcb1" => :el_capitan
    sha256 "4e84d0befabc6218f621c41d7225aa72899d0ff7c248dd0d9e6aad63ba3d133c" => :yosemite
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
