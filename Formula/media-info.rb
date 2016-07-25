class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.86/MediaInfo_CLI_0.7.86_GNU_FromSource.tar.bz2"
  version "0.7.86"
  sha256 "d874dfc62f834b7bb5ac0d2de8e314340b332dccc92f3806dd3b784200ce09d1"

  bottle do
    cellar :any
    sha256 "763823ae26954e097b9d7f524ef1fd54100fdaacd1e93e9d9ffe1156c998afd4" => :el_capitan
    sha256 "4c923aadea52ef2014d0cb4c5eb30bba086c1d747de6f329bd9c4ec74225646f" => :yosemite
    sha256 "c8d690d898856d8bf03079fd1a50a9b37656a4a0f9282b68c38d5ef205f995b4" => :mavericks
  end

  depends_on "pkg-config" => :build
  # fails to build against Leopard's older libcurl
  depends_on "curl" if MacOS.version < :snow_leopard

  def install
    cd "ZenLib/Project/GNU/Library" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
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
