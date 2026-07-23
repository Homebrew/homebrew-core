class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.18.tar.gz"
  sha256 "c4023f1bf59e14ee01aa912bc2d69092cd70a479bbca693ec0d5b47e9445dade"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d96ff8bd06dad573f31ff0e37d56de37c3c3ed9bd0da84b289ef2f41fc6da715"
    sha256 cellar: :any, arm64_sequoia: "81b32eaa8c94f39f35b889f6784c6fcaaab57f1e38baae715c098305f2953a72"
    sha256 cellar: :any, arm64_sonoma:  "c6a076b635b603efdd788058753d36bf7edffcb2db76414b148f208b6ffae11a"
    sha256 cellar: :any, sonoma:        "8efb5ed8908e401cc4af58ce224f15871e7bcca6ba29d6110963c6cc0672ac90"
    sha256 cellar: :any, arm64_linux:   "6f8256221c59ff343334425e540984b74442ec7e495b3564690da6dc8d79f6ea"
    sha256 cellar: :any, x86_64_linux:  "9928402c3476bc2d92dceb6c108f3878e4c8e6b04464543ec2e3ae58055dff96"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      #include <torrent/runtime/runtime.h>
      int main(void)
      {
        std::cout << torrent::runtime::version() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-L#{lib}", "-ltorrent"
    assert_match version.to_s, shell_output("./test").strip
  end
end
