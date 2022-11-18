class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/22.09/MediaInfo_CLI_22.09_GNU_FromSource.tar.bz2"
  sha256 "cbeb09e63d77e10d74ff5ee3c4955f7ff848796f506d64cbed3d6e828632d52b"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f2e869fa9da0e03394450e870142c6242b35763b3dc8b11a262b40008db94cf3"
    sha256 cellar: :any,                 arm64_monterey: "b3046f5d77a86bea2c529b5da95761a79bc2c3d5be42c6e2d5d95a32abbaf959"
    sha256 cellar: :any,                 arm64_big_sur:  "e08e6f4ca8de3e75f4464da131ce3484603b951887af9701c77ba889dd29c0f8"
    sha256 cellar: :any,                 ventura:        "69ed99558190b07f0947df9dabb473f4616ad2e94da045046aa4976e639e81f4"
    sha256 cellar: :any,                 monterey:       "407e1877b42e010881224c3c6bae09d7a986995253c1e575b2bb1dc95d4716ad"
    sha256 cellar: :any,                 big_sur:        "dcc0c42e243b1c9861e8586b1460e1c33e6ba6109ba61972e0f04ff454cfe3ef"
    sha256 cellar: :any,                 catalina:       "eb7a956da46d4b5413487faf81ae12790d0486be771c454c389e4f9937f2d432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddf414c076a1f767738bd9d15faacb82b76a94175f8adea74774e7fa7bdfdfda"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    cd "ZenLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--enable-static",
              "--enable-shared",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make", "install"
    end

    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end
