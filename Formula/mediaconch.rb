class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/16.10/MediaConch_CLI_16.10_GNU_FromSource.tar.bz2"
  version "16.10"
  sha256 "ee9b2fc9baf9c97f7d881918c7784cea21eb91e3deb62c7474160fb2417668df"

  bottle do
    cellar :any
    sha256 "0980c55b293ad3b00feb0dcd67ca244a52a6c2e6957e6c3b017cf1d487e6a7d6" => :sierra
    sha256 "305694c42f2ce6040210e293c341a19c05c9d37313dee6b492d370404c80e539" => :el_capitan
    sha256 "1423d7e4aa5f9eb15e4ee88e674c3fe59bb410c913c3becfc292710f06f0b094" => :yosemite
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
