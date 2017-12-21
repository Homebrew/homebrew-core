class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/17.12/MediaConch_CLI_17.12_GNU_FromSource.tar.bz2"
  version "17.12"
  sha256 "4d27a6f7e62853cf25a761bc0796285ec6bb465c90059b43f741f7498417cbac"

  bottle do
    cellar :any
    sha256 "8e7000926ba5af153e7f1426b83c80e13c187b3ce76f92601b69114d3917ec9c" => :high_sierra
    sha256 "dff233768b0a79dfc3a5affd64828ddadefd1d38bad1012e66d7f1d9793149d2" => :sierra
    sha256 "5bdc739addde0af6dade0401a2533c22658154de075613ed4c26301eadb78401" => :el_capitan
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
