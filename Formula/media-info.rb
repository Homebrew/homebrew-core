class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/17.12/MediaInfo_CLI_17.12_GNU_FromSource.tar.bz2"
  version "17.12"
  sha256 "0f23ccc9a78b24104dc387691e1df484ed75350ee77277982cd170cca59750b0"

  bottle do
    cellar :any
    sha256 "96d5d7c27619acb21217a6b982d16e4318d60d5f68e5e40240e9549dd0c105b8" => :high_sierra
    sha256 "66f93ac922c8a75067f0c069e3a70feb1f6eaac69ca9ab34923cd4c1ff7c7bdb" => :sierra
    sha256 "b992a076c1de1fb5da7b7ceed5abb52814f07a2c21af2d4a88996b0f5bddc33e" => :el_capitan
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
