class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/22.03/MediaConch_CLI_22.03_GNU_FromSource.tar.bz2"
  sha256 "0c35434b55c7f507b20ef13e0a33fdbc4868cca353b145abb5d2cd13c7f11f23"

  livecheck do
    url "https://mediaarea.net/MediaConch/Download/Source"
    regex(/href=.*?mediaconch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "519bb9c709793e1e9343f69087b4832be1392220066ef5a37b60ea4f51e1f726"
    sha256 cellar: :any,                 arm64_big_sur:  "acf1493abb7e5a14c276a831addd076a584d30d60b9b8e9373993808dedfbad2"
    sha256 cellar: :any,                 monterey:       "88974c4a26e78c494cd4f641323ecc4c561946ccbdb7f5968c824acbc856d5e0"
    sha256 cellar: :any,                 big_sur:        "5f7e218f55ae40cd50c45c6188f1a6f5314f87d24081eac338a2613bfcde104e"
    sha256 cellar: :any,                 catalina:       "a82bd4c853e0473e4285fbced7c1011a7d0b3950d6ba9ecf6530e8e4482b10de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d79bbbe98490ee3ba70a07ae4fe2fb14cba2cd42b3cbfc49638dc46b9c7a13c2"
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-shared",
              "--enable-static",
              "--prefix=#{prefix}",
              # mediaconch installs libs/headers at the same paths as mediainfo
              "--libdir=#{lib}/mediaconch",
              "--includedir=#{include}/mediaconch"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-static",
              "--enable-shared",
              "--with-libcurl",
              "--prefix=#{prefix}",
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
