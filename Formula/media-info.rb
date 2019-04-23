class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/19.04/MediaInfo_CLI_19.04_GNU_FromSource.tar.bz2"
  version "19.04"
  sha256 "fdd3de83d09e85d6b9ecb8b74e86f2fed31d424621adcd5f01b020a214bc7931"

  bottle do
    cellar :any
    sha256 "df5324630ddc624855232a41320894c29aafcac60254b68c85a70ed40544fba0" => :mojave
    sha256 "7dd026a2e9c60ff8eff7f688dc776e00f7d7cbc70f92699151da3d771e1bb4c9" => :high_sierra
    sha256 "84970690098c48fd0d165c987190aedd4bd69a6d60c86ae1153772371e11c62f" => :sierra
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
