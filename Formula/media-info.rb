class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/20.08/MediaInfo_CLI_20.08_GNU_FromSource.tar.bz2"
  sha256 "4e400b80870c144d549d65c845e0e745050d9512cbf21d1c2f53d70f60492c0c"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "d2d02196a863e262a5437917d4171ecc0cd6ee04af9aa68afdd91a11c0edfc84" => :catalina
    sha256 "f0c39a5f20693be853f15a2424541eb009b539508e5719ceea99f15177613d86" => :mojave
    sha256 "43a6de49a3e7ebe1fa462da717c18cc8fae8668d713677cc417d995c37ed37ae" => :high_sierra
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
