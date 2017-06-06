class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/17.05/MediaConch_CLI_17.05_GNU_FromSource.tar.bz2"
  version "17.05"
  sha256 "1c8fb8b38f170d9f5d009550068a54986c92eb3e93d9b6b72f60fbd4cef68a66"

  bottle do
    cellar :any
    sha256 "f1d00bb4bc0adb9d3f211b551d8a61b00e91a23443a4a960b6912be40aedd1bb" => :sierra
    sha256 "d996f12c6338d4f0b46e7c8476cd56f959c4497747b72d2ab7b19083dcb2feac" => :el_capitan
    sha256 "7043592c8a2c3c92246baf4d4dc7277279ff629664cf7e6207faa1b43b4f1e57" => :yosemite
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
