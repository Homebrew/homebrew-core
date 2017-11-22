class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/17.11/MediaConch_CLI_17.11_GNU_FromSource.tar.bz2"
  version "17.11"
  sha256 "2bca86f6281231d0432c7630b6b42480b0d445089d343abf85f92f278b62d9d0"

  bottle do
    cellar :any
    sha256 "fc96b3e48c4e7587ce8371cfeeb99f9d664eb3ccdcc14b296a9f36144b2ffb16" => :high_sierra
    sha256 "1a67f8876d96e0569d6c7914a6ece7fb383ed46e1805192842e79f0656a6fdc7" => :sierra
    sha256 "94029f835f3846bd8ffba1524e227c386c803070821f471fc7a8e5f8e4d3ddcb" => :el_capitan
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
