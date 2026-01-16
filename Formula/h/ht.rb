class Ht < Formula
  desc "Viewer/editor/analyzer for executables"
  homepage "https://hte.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/hte/ht-source/ht-2.1.0.tar.bz2"
  sha256 "31f5e8e2ca7f85d40bb18ef518bf1a105a6f602918a0755bc649f3f407b75d70"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:    "24189de18e537de36a5368d5e5a9e1017f07b25e16147467763496ff865e4a1b"
    sha256 cellar: :any,                 arm64_sequoia:  "4dcd72bf389cc8babbb16008ededd722842fa9a5fb3141cac62719e06931f7ff"
    sha256 cellar: :any,                 arm64_sonoma:   "94baa4793d98e0b2b965672e0881cbf1a5b4c85fab1f6f32b1a13553ffd4dddd"
    sha256 cellar: :any,                 arm64_ventura:  "f429f9b9cd7181b2f6ab5f7d75314c975657fe21ab2dbcb4a193b1a090f12bfb"
    sha256 cellar: :any,                 arm64_monterey: "c3cc295c38e1b904ca509a7bbbac2d1a927aa07eb7c1be789c9228b329387be4"
    sha256 cellar: :any,                 arm64_big_sur:  "67aa1b783d01e759a908a568cfc1715e614bff7b77171fc82af00e2af682b464"
    sha256 cellar: :any,                 sonoma:         "6700769f0daec8cafcaf7d16f9bd6b1e1a7fc3e7afd5011717b7b48368699b7b"
    sha256 cellar: :any,                 ventura:        "d704c8f0d899b257967d3478cbeb1e2c093a71e28402747722842908e1e2eff6"
    sha256 cellar: :any,                 monterey:       "cf85f1fc8724c40f8f03a109f8a39b35e84358796b8fe17de1e907f49dcad53f"
    sha256 cellar: :any,                 big_sur:        "68a9ebfab03bd7d4f5e61d26075d07ee692002a07b8e5f201ae84ebbac45e5dd"
    sha256 cellar: :any,                 catalina:       "75ab4e842bc671346e7e75ef512f5f2b3d55008a07d91437a9ba46e9c9dcb1b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "63afc8ba699c8e8182ac6271c69f9c52ac4266e4ef1e61b61fcf391339053121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b74b56b840ef0c1ccbba640ef5625dc0b4f24c6b89220eed18769084064ca590"
  end

  depends_on "lzo"

  uses_from_macos "ncurses"

  conflicts_with "texlive", because: "both install `ht` binaries"

  # Apply commit from open PR to work around build failure on Apple Silicon
  # ld: building fixups: pointer not aligned at _coff_characteristics+0x1
  # PR ref: https://github.com/sebastianbiallas/ht/pull/31
  patch do
    on_macos do
      url "https://github.com/sebastianbiallas/ht/commit/a721310665267655d37d9e80db5234d2a7731895.patch?full_index=1"
      sha256 "def983c542112d66f472a4a32323948f812bdd30bb1aa54abc5cb5b3ffef1752"
    end
  end

  # Fix C++11 compatibility issues
  patch do
    url "https://github.com/sebastianbiallas/ht/commit/e52dfb86aa2c370d7d1ac2e046a4b9babc93bac9.patch?full_index=1"
    sha256 "0119c3973d2cc4ac56c7f28061ce0426eab169695ae7b81e1514f9347740ab26"
  end

  def install
    # Fix compilation with Xcode 9
    # https://github.com/sebastianbiallas/ht/pull/18
    inreplace "htapp.cc", "(abs(a - b) > 1)", "(abs((int)a - (int)b))"

    chmod 0755, "./install-sh"
    system "./configure", "--disable-silent-rules",
                          "--disable-x11-textmode",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "ht #{version}", shell_output("#{bin}/ht -v")
  end
end
