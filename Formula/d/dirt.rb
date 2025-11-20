class Dirt < Formula
  desc "Experimental sample playback"
  homepage "https://github.com/tidalcycles/Dirt"
  url "https://github.com/tidalcycles/Dirt/archive/refs/tags/1.1.tar.gz"
  sha256 "bb1ae52311813d0ea3089bf3837592b885562518b4b44967ce88a24bc10802b6"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/tidalcycles/Dirt.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "298bd387a65d1a91e835350f47a97b76af44b9466b32b8c2c3a7b67e03736b8c"
    sha256 cellar: :any,                 arm64_sequoia:  "dc07b263a5ea080c3ae14aaaabe185d07c84189e6708cc2206ac74d62e67ec3f"
    sha256 cellar: :any,                 arm64_sonoma:   "dc0671b289e79190e0d962b995c11ba8d0f828fb9a9903c5981e8a7fddca28c0"
    sha256 cellar: :any,                 arm64_ventura:  "7b0e123381c73cf489c38368999dcf0886843f8223562f83db6b6a5fde4dcaf7"
    sha256 cellar: :any,                 arm64_monterey: "6ac9e97def1a071fda1e4fc145450cdafed11444358537d2824cea8d77e73155"
    sha256 cellar: :any,                 arm64_big_sur:  "ed0c1c48b840abfd9336d6b292e1e08896bddc3663164815fd6fc489b0d3495e"
    sha256 cellar: :any,                 sonoma:         "938298f9f34341b030fec41d4b61002a75ef6a626b7b6a9479584581e52f569c"
    sha256 cellar: :any,                 ventura:        "5ff0f05492f68f79315dd99ce136a09cfb3455b030bf1a12d9164f4dee70b43c"
    sha256 cellar: :any,                 monterey:       "f4c8eaef7bd081e9c346af24400410671665836820077afdcc13e68c676903bd"
    sha256 cellar: :any,                 big_sur:        "bb32869ee985043d05056f89254e369dcc8be8cfaaedaa1427787fc5e04fa62c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1ed29d734b4fb03efa5e07a439a7f12b61df0904f8cf4073354ecb2a879eec7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ea04b1e39b56f30179c50763b52314bb909285924d3229a68c35905e6b9b0f6"
  end

  depends_on "jack"
  depends_on "liblo"
  depends_on "libsamplerate"
  depends_on "libsndfile"

  def install
    # Work-around for newer clang
    # upstream bug report, https://github.com/tidalcycles/Dirt/issues/66
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `...'; ....o:(.bss+0x0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    inreplace "Makefile", "gcc", ENV.cc

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dirt --help; :")
  end
end
