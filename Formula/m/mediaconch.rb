class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/23.10/MediaConch_CLI_23.10_GNU_FromSource.tar.bz2"
  sha256 "c044830cc4ea3b4f947dc356d394760457388d53c58dcb173744dfbed5433200"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/MediaConch/Download/Source"
    regex(/href=.*?mediaconch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f81d8219881b196a7a999fd5e1b8ea72a30279542bdac7676f36f340c02f7ff"
    sha256 cellar: :any,                 arm64_ventura:  "6a733e41337e73a98d264e238ec8f1a48c063721894fafd3433693fc5610901e"
    sha256 cellar: :any,                 arm64_monterey: "942ffbcb3f95e5a3420d737583a08697c0710c826519530e79d8bed697e846c6"
    sha256 cellar: :any,                 sonoma:         "dd141ba9d9332f82996f2416d011a1d7818145bf0364cc7c56ee45ffeacbff3b"
    sha256 cellar: :any,                 ventura:        "943d279cc5c5628779951ed2d3a1a20b2b968f4d3b829e90735655f8ae74d535"
    sha256 cellar: :any,                 monterey:       "8e8da3bc1e6dab2c4bb150a9e4de66d6444bb150500330572ee12df0ebd163a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f786d2972cc425151cfca44927569b05f1ce8e905b9573b4070a0e3f453c8722"
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
