class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/17.01.1/MediaConch_CLI_17.01.1_GNU_FromSource.tar.bz2"
  version "17.01.1"
  sha256 "a935084cd3fcd066de23e33a88a33cf36f447c88335f7518854495f5b8651f75"

  bottle do
    cellar :any
    sha256 "a6b9df8e41ef34914d1554a331b60b31ea2b011589a1b17ede17c697359ccffd" => :sierra
    sha256 "42a8e6f27752966854ad1fdd5bf654d6b05be5abc8e1e62273109e12b4192a82" => :el_capitan
    sha256 "448758e1ac81dcc4d45b485af8bc01bb50fd8cdca766aab7e3ee0898c6d0bb60" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"
  # fails to build against Leopard's older libcurl
  depends_on "curl" if MacOS.version < :snow_leopard

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
