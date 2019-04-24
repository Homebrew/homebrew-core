class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/19.04/MediaInfo_CLI_19.04_GNU_FromSource.tar.bz2"
  version "19.04"
  sha256 "fdd3de83d09e85d6b9ecb8b74e86f2fed31d424621adcd5f01b020a214bc7931"

  bottle do
    cellar :any
    sha256 "b8dd9d52888d0cd92da22fad6b896a757269961c4d94c7136e5c79b4aeea6f36" => :mojave
    sha256 "3dbda8ffbd8af33d17b6d7e290d40be1a8cb3e7c0088b4e4545ebfe7baa3dabe" => :high_sierra
    sha256 "05cf959783f2137cdb7e35df7135a71bb6eda02dec2dc6ac2b66b82f4e0cfd99" => :sierra
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
