class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/20.08/MediaInfo_CLI_20.08_GNU_FromSource.tar.bz2"
  sha256 "4e400b80870c144d549d65c845e0e745050d9512cbf21d1c2f53d70f60492c0c"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/download/binary/mediainfo/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "14b8e57b2773a7ebbf442d7778c1ac1405a3911d991349d3b14f5f2afc094edf" => :catalina
    sha256 "530635532cdc64af8c37ddac3d1f944802f89e2977ef73974b2ac7060248aff8" => :mojave
    sha256 "52f5c532a920c9ec13b1623ab6c9cdf52a8580b7c91bdf6a0579716d52066096" => :high_sierra
  end

  depends_on "pkg-config" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

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
