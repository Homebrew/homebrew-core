class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/17.06/MediaConch_CLI_17.06_GNU_FromSource.tar.bz2"
  version "17.06"
  sha256 "96297513e1cb2ee12e87ff3488ac60f98d0f67a5a36a67b91314a8ec12620158"

  bottle do
    cellar :any
    sha256 "f6d2467c8ff9a5137fd789a2386547f2f041bf8e7d4459d7a88a194502bbd5ac" => :sierra
    sha256 "7e36a877ad54bd09aec2b1a17f3d92ad7a1962e79233a39ffd1f60bee63a7150" => :el_capitan
    sha256 "ae9ec9729e0b203a4257bddfdeb7d886ff1d03c0cf4a5e425efaa9651f8245c3" => :yosemite
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
