class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/24.06/MediaConch_CLI_24.06_GNU_FromSource.tar.bz2"
  sha256 "2dd68a260ea84fe23031c2caa121ede850f34a8c733e53237205bd018af0b9d9"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/MediaConch/Download/Source"
    regex(/href=.*?mediaconch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b1c07f44e462b03a77dfcc566a7d2c814e8d9f6c366c84f33d52116e86e5437e"
    sha256 cellar: :any,                 arm64_sonoma:   "939859b3e6b27cea95e30dd0249430f53e50dd2482d9e5910089372e1442bc2b"
    sha256 cellar: :any,                 arm64_ventura:  "e377a3a11dd83320786791b39c255446d8097c154a61d5bcb49409a156faf526"
    sha256 cellar: :any,                 arm64_monterey: "aa33f61f409e854a4a03ca69de8371ed7a47b872b33928b650662325776ad206"
    sha256 cellar: :any,                 sonoma:         "5d2cec68e7f1e6b3b5ca0fbbbbcbba2a40dd88c258f4149d8462ddd34100b1e9"
    sha256 cellar: :any,                 ventura:        "056b82ae9504a3eb15b18d66fe79e94c12c837ed3714faa88009793a93052b52"
    sha256 cellar: :any,                 monterey:       "70c1594d43d848825434efaf63b21ac294cf0758b53f0fb5bb0da6a22f87f8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc3b5ed1de5f34d66934807b79a38a3fb34b9bde991a6b7172db384e1da19a86"
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "sqlite"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

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
    output = shell_output("#{bin}/mediaconch #{test_fixtures("test.mp3")}")
    assert_match "N/A! #{test_fixtures("test.mp3")}", output

    assert_match version.to_s, shell_output("#{bin}/mediaconch --version")
  end
end
