class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/16.09/MediaConch_CLI_16.09_GNU_FromSource.tar.bz2"
  version "16.09"
  sha256 "e85d99ffbdbd45f77b953692fb39fabc89745a4811ecc5729223b264ebf77b54"

  bottle do
    cellar :any
    sha256 "a855eaf364a91accdbc0bb93bf682476266fb9a36a2e7d0ac0514b9caa41737f" => :sierra
    sha256 "4d718177f09aab18af88c7877e91eb2028d43e85515ecf92a8396557aee15fac" => :el_capitan
    sha256 "63023e82f3cfbdd6ab8b90f7b5fa50fe428bebd1aeb4247b1f9a4e559c053eff" => :yosemite
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
