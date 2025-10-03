class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "ca3b96bc478db2cd282ccb87b91b169662d7c9298dbca9934f8556c2935cab73"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f91c420b639b5d60486ee42a655d4e5321794988de412abce563c8c979f4c0d2"
    sha256 cellar: :any,                 arm64_sequoia: "92d392e3387c7e9b8b0aee4d0880746ff2541a2531188e612b50078f8eddb0b7"
    sha256 cellar: :any,                 arm64_sonoma:  "549296e430bd7cecbb83bbc445d51a8c28b6125ec56872082fbf6251472f6765"
    sha256 cellar: :any,                 arm64_ventura: "4d3da8cd5e92a66a8b6da8a3bd538b7ed4c26228cb68ae473475dab986d6cb39"
    sha256 cellar: :any,                 sonoma:        "6634c748ecfa16093db13068a84f8c928f8bfa0d31e3f22146855c042c0b0ed9"
    sha256 cellar: :any,                 ventura:       "66d5294dccd2d10af953f8386b6dd3e8d0b9b31a08b5b33b97609531305aaa59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e00ccd0af020b3bdc6503a2f183a14cf5e6ea85f251fc09a5022eb32a00f2a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f5ae6dc91733225f0ce84355ac6594b528665cf53977f1b10c7aedaf56b8a69"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "libtorrent-rasterbar", because: "both use the same libname"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>#{"  "}
      #include <torrent/torrent.h>
      int main(void)
      {
        std::cout << torrent::version() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    assert_match version.to_s, shell_output("./test").strip
  end
end
