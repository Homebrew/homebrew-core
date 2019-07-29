class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/18.03.2/MediaConch_CLI_18.03.2_GNU_FromSource.tar.bz2"
  version "18.03.2"
  sha256 "8f8f31f1c3eb55449799ebb2031ef373934a0a9826ce6c2b2bdd32dacbf5ec4c"

  bottle do
    cellar :any
    sha256 "8828246691975f172635147cf5f89ce679397112288276d3fcde40252edc637f" => :mojave
    sha256 "d888f17d7347095c3516e1a51238fe01636578c1a2cf1d3e0162bd05e027ed5e" => :high_sierra
    sha256 "07b38dfc6333a72b2333562fc017ccb175a91de98d21c4046c445b62e7dbeb6a" => :sierra
    sha256 "b110435077f1d4164238760baa2bfaaa5e63b3a49a9600a86d710cfefc594e89" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"

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
