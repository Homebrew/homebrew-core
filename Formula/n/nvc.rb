class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.12.0/nvc-1.12.0.tar.gz"
  sha256 "68d43db9cdfdfad3cf5a45fa08ed20900733c9f3799117f8f5e10744af79136f"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "b075f20648d94e176131d0b80ece517631b06151bbc923118a3355d8257c15c3"
    sha256 arm64_ventura:  "5c119fea28c0af1b6085e28ccdd633010043a0219ea558a4a0fbda418d1f0fc6"
    sha256 arm64_monterey: "2fd3b582a9b60a054c3dffdfff7555c4139e007f9e8c168a7e64aa80a2f7655b"
    sha256 sonoma:         "2140633d44b4fe48f791d0c319d1a36a8c5a581202f366cd4e617354ed6dd8ad"
    sha256 ventura:        "f27c42ba7de89e7b0626054808b7b329b4417ecd0e2888d942d62c4bc03ef68f"
    sha256 monterey:       "d946186a51d11f629c1ffbed0f77736d71be33838da001b1d5e91e9781e211cb"
    sha256 x86_64_linux:   "d47a62a1b1152da36591f2adc90901f2aba1843033b119040158f518727fd02d"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@17"

  uses_from_macos "flex" => :build

  fails_with gcc: "5" # LLVM is built with GCC

  resource "homebrew-test" do
    url "https://raw.githubusercontent.com/suoto/vim-hdl-examples/fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b/basic_library/very_common_pkg.vhd"
    sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
  end

  def install
    system "./autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    ENV["ac_cv_path_linker_path"] = "ld" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "../configure", "--with-llvm=#{Formula["llvm@17"].opt_bin}/llvm-config",
                             "--prefix=#{prefix}",
                             "--with-system-cc=#{ENV.cc}",
                             "--disable-silent-rules"
      inreplace ["Makefile", "config.h"], Superenv.shims_path/ENV.cc, ENV.cc
      ENV.deparallelize
      system "make", "V=1"
      system "make", "V=1", "install"
    end

    (pkgshare/"examples").install "test/regress/wait1.vhd"
  end

  test do
    testpath.install resource("homebrew-test")
    system bin/"nvc", "-a", testpath/"very_common_pkg.vhd"
    system bin/"nvc", "-a", pkgshare/"examples/wait1.vhd", "-e", "wait1", "-r"
  end
end
