class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/18.12/MediaInfo_CLI_18.12_GNU_FromSource.tar.bz2"
  version "18.12"
  sha256 "7cd7341a3d0a7e50671ffc3637b6e5af07acadb4becd34d0f5b8dc927def0df9"

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
