class LibtorrentRakshasa < Formula
  desc "BitTorrent library with a focus on high performance"
  homepage "https://github.com/rakshasa/libtorrent"
  url "https://github.com/rakshasa/libtorrent/archive/refs/tags/v0.16.15.tar.gz"
  sha256 "ad2f694cc1dfcc1ed439e8ca4421e20991b26e19be8de411cb66b72e9a8377cf"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "74fbe17a8ba4e6a7448bc5898ebe45b73e337925f330a4894fd609472fb0d1ce"
    sha256 cellar: :any, arm64_sequoia: "39da9f22a741aa8cc097cc3eae73b2c6cca1b3ad884d96c3022133c1b176707f"
    sha256 cellar: :any, arm64_sonoma:  "4fe44d3d75bde11e6cc9aa5d5e106a0fb972763027bc07b06ea03fa4e1df14e7"
    sha256 cellar: :any, sonoma:        "254a394a28a14a7018324098000763346b6c6dc1cc2e873d420425c8747c0b1e"
    sha256 cellar: :any, arm64_linux:   "7a576aa2da75c57b7416d960b9c8efe6537dec6e3c9031892f5a05760d57f108"
    sha256 cellar: :any, x86_64_linux:  "74e3130dc7a78b6c30c0329fb909e3cc95be7ac94e323632589025055d1c5010"
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
