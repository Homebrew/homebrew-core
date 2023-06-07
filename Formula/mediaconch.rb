class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/23.03/MediaConch_CLI_23.03_GNU_FromSource.tar.bz2"
  sha256 "72628e0655a586d81abebfb695b76e8b3a6891e00e274d6f08c083e486717186"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/MediaConch/Download/Source"
    regex(/href=.*?mediaconch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c828d2d511e8f4297678464365300504ae100a28fb70c8e5ee5e67408e92a1f1"
    sha256 cellar: :any,                 arm64_monterey: "1b3c60a699829a71dae1482030ceaddfe76604ff3eae79043d879e37f261a2f4"
    sha256 cellar: :any,                 arm64_big_sur:  "e85f017f01192122a0f9f10639c93542a3507003e5e7d331262b417c0fd5d87d"
    sha256 cellar: :any,                 ventura:        "05018ed135264ef4df0ef4f065e7f6d85f3af3b2a6d3a921b6b57658637de34f"
    sha256 cellar: :any,                 monterey:       "0bb7bc111a7dca1875bc604197787b9c5254873fdddaf8b9f64c7ea45c27cdbf"
    sha256 cellar: :any,                 big_sur:        "4cdaaa62f948d2e8c474317ec3f3b0d2f959bf54b537dd672b5313252f03dbf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7affefea95feeb19c5fc24eed0943daebb263023d4cd1d790fc8dcb9af451d02"
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
