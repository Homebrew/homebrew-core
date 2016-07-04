class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/16.06/MediaConch_CLI_16.06_GNU_FromSource.tar.bz2"
  version "16.06"
  sha256 "cdd6c9199ed6833ae982a28474cdf41c9d60c4c45794d056935b963077f36196"

  bottle do
    cellar :any
    sha256 "6eb51c46cddd82aba7bf8e54bc9e4b2bc16303864cec5a954aa9607ff5d0c411" => :el_capitan
    sha256 "919f7bb2ee69dd08a59fc766bc798dbb2fc7819a402469044691d97b599f4e6d" => :yosemite
    sha256 "b3121831e355c509b5853436ef63253e9044bfbe5ae12a76310dbad5735a0e24" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"
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
              "--prefix=#{prefix}",
              # mediaconch installs libs/headers at the same paths as mediainfo
              "--libdir=#{lib}/mediaconch",
              "--includedir=#{include}/mediaconch"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaConch/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediaconch", test_fixtures("test.mp3"))
  end
end
