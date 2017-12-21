class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/17.12/MediaConch_CLI_17.12_GNU_FromSource.tar.bz2"
  version "17.12"
  sha256 "4d27a6f7e62853cf25a761bc0796285ec6bb465c90059b43f741f7498417cbac"

  bottle do
    cellar :any
    sha256 "ff2b2732e109129ff232a08e47c766bce2fd7838515f9d1722a458301df37d50" => :high_sierra
    sha256 "42bd7119437f6c336b61d53ac30b46cdfd01e70274dc0541bcff8c41e4768fd1" => :sierra
    sha256 "96d7cb85c0a869775f89f26281fbd9824457be097431d8f62d91888e87473f69" => :el_capitan
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
