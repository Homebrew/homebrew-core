class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/23.06/MediaConch_CLI_23.06_GNU_FromSource.tar.bz2"
  sha256 "5ee399d60c722cee31db0a52346b2fea429218d09a5fd8fa95422b44a1228c1a"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/MediaConch/Download/Source"
    regex(/href=.*?mediaconch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9bdb488a6c40a6d5bd84a2841540cc94d4ccc9a4ffcc4d509256e62296883987"
    sha256 cellar: :any,                 arm64_monterey: "9985e4ba94c69e091e03328eafe3391bc13ec3fab6aec864cc6172d591a552fa"
    sha256 cellar: :any,                 arm64_big_sur:  "bfc0b525024ab496c30e4b6cd4b6c36b0d1d46f9e89a8fba92aa69062057d22a"
    sha256 cellar: :any,                 ventura:        "653501e28a15b2d1557c387c766a935c2a3aa19f6757527fa16b2885c56a02ce"
    sha256 cellar: :any,                 monterey:       "2494377f14f4431968a1705e396cf7be5f7231f7386252634ac5f4bbf539d0d1"
    sha256 cellar: :any,                 big_sur:        "87dd3ffcb3b22e455bed1894affa94cc16110b4058f73333339bce2c5246a3ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab306848ba064b8fee8701d7e40d3e1ed0213b5d0b2078d4ab23ecdb8f41ce7e"
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
