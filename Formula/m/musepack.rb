class Musepack < Formula
  desc "Audio compression format and tools"
  homepage "https://www.musepack.net/"
  url "https://files.musepack.net/source/musepack_src_r475.tar.gz"
  version "r475"
  sha256 "a4b1742f997f83e1056142d556a8c20845ba764b70365ff9ccf2e3f81c427b2b"
  license all_of: [
    "BSD-3-Clause", # mpc2sv8, mpccut, mpcdec, mpcgain, wavcmp
    "LGPL-2.1-or-later", # mpcenc
    "GPL-2.0-or-later", # mpcchap
    "Zlib", # common/huffman-bcl.c
  ]

  livecheck do
    url "https://www.musepack.net/index.php?pg=src"
    regex(/href=.*?musepack(?:[._-]src)?[._-](r\d+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "545fb3f5f74e2fc5acbbbfbad61b0dfb6c261cd7dbd26f998c1931c939086bd0"
    sha256 cellar: :any,                 arm64_sequoia:  "d84a9ad759b25d445781d6e1e5af5247431427e00e90bfb0b1014d9c2e6e4bab"
    sha256 cellar: :any,                 arm64_sonoma:   "6b1cd3fb3a8b8beb5603ce39e237cd7fb04e71e8e46ac9d63b0904067e57e676"
    sha256 cellar: :any,                 arm64_ventura:  "72634f1bab6447c671827b1586e2161487273e4737b0cc7e47100a8d1f33cc4e"
    sha256 cellar: :any,                 arm64_monterey: "76db5599c7e47ab4317292c040ef16095f658ee3b524d89c0296a574380a4570"
    sha256 cellar: :any,                 arm64_big_sur:  "ce4329e0fc5d5d1a1e518e7c1f471ef300ff96ddaea0219e70e4408924f75ff6"
    sha256 cellar: :any,                 sonoma:         "6a7652681b271cbcffdd9ac69f7394ee9c51460bc2efaca5ed684913b1b22199"
    sha256 cellar: :any,                 ventura:        "772444ef289c9324ef9063d4ca8bc4626080f053589bd93b994e410183c9ff2e"
    sha256 cellar: :any,                 monterey:       "9f74dcc9567656a42082125ce4d758c3318a452dbd940b6db39b72c4981768da"
    sha256 cellar: :any,                 big_sur:        "e9221e9612e1c0134554fbf380639cd995a5970ad34702bea371633f121ffb3e"
    sha256 cellar: :any,                 catalina:       "847cacb946b6289a5fbfbfe4e1a38f1ec5b7f1e32d6c12145aaf1044317e4ce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0e70b9117f455bbd6f17bd6d2467c18f55067b51933a71b15b07b713c30687ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0d6143e42529aa943d6bd1ecebf0e1d0c85576eaab847692c9588a37a0ce1f7"
  end

  depends_on "cmake" => :build
  depends_on "libcuefile"
  depends_on "libreplaygain"

  # Backport upstream fixes from SVN for `-fno-common` and installing shared library
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/musepack/r479.patch"
    sha256 "efef0421e3bb25c065c5e77d6c2e4bcdcc89fbcb03c7a7cfd7565ee5478fc8ba"
  end
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/musepack/r482.patch"
    sha256 "b147cc7effe9230401a0a865fdea1805be8eb26a24059bb36e39da1012e8da4b"
  end
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/musepack/r491.patch"
    sha256 "9003ff9c3e939dc880cc1ab1a46626eb9cf67a27b2610e7bac0945256bbb5cab"
  end

  # Apply Gentoo patches for fixing parallel build and another `-fno-common` issue
  patch do
    url "https://raw.githubusercontent.com/gentoo/gentoo/f5d4d4995d45baf77c176224b62e424dca037aef/media-sound/musepack-tools/files/musepack-tools-495-fixup-link-depends.patch"
    sha256 "6dbada5a1e90c8fd1fe60084c04e2193cd027c6959ecaf6a37151a674ddb6a77"
  end
  patch do
    url "https://raw.githubusercontent.com/gentoo/gentoo/f5d4d4995d45baf77c176224b62e424dca037aef/media-sound/musepack-tools/files/musepack-tools-495-incompatible-pointers.patch"
    sha256 "25b43fa3ad4ae6eef1e483e3b675b521049901809a024e22aa0aee2237501654"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "test-mpc" do
      url "https://trac.ffmpeg.org/raw-attachment/ticket/1160/decodererror.mpc"
      sha256 "b16d876b58810cdb7fc06e5f2f8839775efeffb9b753948a5a0f12691436a15c"
    end

    resource("test-mpc").stage do
      assert_match(/441001 samples decoded in/,
                   shell_output("#{bin}/mpcdec decodererror.mpc 2>&1"))
    end
  end
end
