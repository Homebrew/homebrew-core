class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/22.09/MediaConch_CLI_22.09_GNU_FromSource.tar.bz2"
  sha256 "7ce9c4ac76b395029f86d9bed92dd1031375e4387758c9a9fb7275461300cef0"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/MediaConch/Download/Source"
    regex(/href=.*?mediaconch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b50b3309915cf885c17bd8bae2b28914b4ad75dc39c39885d63dcbd00d0addb2"
    sha256 cellar: :any,                 arm64_big_sur:  "a07b8e83f9eae756d297567c28fcfb02432a2c527b2da31149c73914ba5251a1"
    sha256 cellar: :any,                 monterey:       "df6e1f485e1ee0e0fc3207ed609a1aea8c49cb7a09fb06374bd3742c666627c9"
    sha256 cellar: :any,                 big_sur:        "cb73095a4412e37d1ebc36f6b3e55726e892d858fae99055e8a525b1b1310ea6"
    sha256 cellar: :any,                 catalina:       "bfc13581c53976d8a732f160e853869c462117a8731075f7c7a35b5de85d0c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d786d22f5a5473ce40a2d4425877092b3823e8ade39ad2117e6b6310998ae82"
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
