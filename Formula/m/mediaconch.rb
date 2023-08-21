class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/23.07/MediaConch_CLI_23.07_GNU_FromSource.tar.bz2"
  sha256 "3e1bbed484d211a17c829f725c45e67a2debfe72e8ee096609e3a42d09f2fa16"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/MediaConch/Download/Source"
    regex(/href=.*?mediaconch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1d87c27cda5fe315dbeb928fe6e670bcfcfffd2a133da79107ec23cbbd509ce6"
    sha256 cellar: :any,                 arm64_monterey: "6115cb56a93089c7231b9b078c9242311da425efb1068257e9b19d47bfbd8d8a"
    sha256 cellar: :any,                 arm64_big_sur:  "a8ff06ef886d77d76ab980e366ac8d8a74d67d41ab4240a7994273cb282a55a0"
    sha256 cellar: :any,                 ventura:        "82cc99ba8e67e4ff478c50824072459bbdd3258a0e3a79328561b355e03367f2"
    sha256 cellar: :any,                 monterey:       "a3008f2d281cbce671f2f829fc52be9842fd29c525b7b097967bba92b53db8ff"
    sha256 cellar: :any,                 big_sur:        "2b2895791d1e5f95163ee7b32bbb2921a870f057ae4547c8357a52cd23dc0efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc0456b88a06d388cb0aa3ff54c5e4f1b8c897e6abdd8888337ae44be8c3ca66"
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
