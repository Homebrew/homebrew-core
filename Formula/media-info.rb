class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/21.03/MediaInfo_CLI_21.03_GNU_FromSource.tar.bz2"
  sha256 "75adafad4f1bd3259354a50ae491de6929649c14c71998cf5a2ed176d298b011"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/download/binary/mediainfo/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "58327daa2bf57fde48a3732800db64c12ac787db06841e11e53a41fcd55b7559"
    sha256 cellar: :any,                 big_sur:       "cd0ec2b21f22cb356f5e93dfa14e67d3d9a94e12923a1c84d58b1f74d0160c20"
    sha256 cellar: :any,                 catalina:      "83b8a3b1b8708fe1c1ec7c1e2856d29a074e14441cf7aecfe7b6cae2292253fc"
    sha256 cellar: :any,                 mojave:        "f67aa010d9fc345917e29ea1cbe232360396851bbe9b770af084f49fdd70dfd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6edd256ab76a2fb6659bcbbd30d086431331a16d7322ad30263496c13606f8e0"
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
