class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/0.7.89/MediaInfo_CLI_0.7.89_GNU_FromSource.tar.bz2"
  version "0.7.89"
  sha256 "465cfedb12708cca5763a7db56b6218ad7835e874bdae45d2f835073457caeee"

  bottle do
    cellar :any
    sha256 "b9743d605934bc96aa7e54597da81038fc227ed1c94b84088291fc2b89d9fb57" => :sierra
    sha256 "2baeab9de8996b6ac678777469ef03cac982b052b297dbbea306318c9fb79748" => :el_capitan
    sha256 "69d5244699b6697c2c055d52fcc43f5c60bca0f00c738e46f69ed11c503d0e6e" => :yosemite
    sha256 "b1e225b7f720f39c9eea2a84b0ec7ccea41021afc7acd58ba12442921ea974f0" => :mavericks
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
