class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/23.03/MediaInfo_CLI_23.03_GNU_FromSource.tar.bz2"
  sha256 "1c6692bf146ee107ee224af20c28ed5acc6879a8584be51914c4f212d56fe205"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c5399b91bb27cf1f621d6bf22745e12fac04960767bc639c63b7c81a1b422875"
    sha256 cellar: :any,                 arm64_monterey: "850b3080d7caa28a46cb9e8314a0b94ecdaae1b5a6d62ef942188af91a9d5c2c"
    sha256 cellar: :any,                 arm64_big_sur:  "47367855cbfb8c9b484aca033aa04dd0b4feb8fedf778bd7b8b882c9606f2af5"
    sha256 cellar: :any,                 ventura:        "24b35b729ca293f92eba27d956127ff05e33c9e7642cb1cce944d0f18d2176d0"
    sha256 cellar: :any,                 monterey:       "6b7ce10b7388c94419f727e203503c1b2003ed8e95c0ec14c9afc467cabb389a"
    sha256 cellar: :any,                 big_sur:        "94ed253108c3393bccc6161d7f5ef1b35c602214b9a362b58b3c5fce7509dd04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e61eabeafb79f5e5451ff350d46263d2fa902c76cf35380cd6b4cead7fe684d"
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
