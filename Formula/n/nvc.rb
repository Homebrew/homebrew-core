class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.10.1/nvc-1.10.1.tar.gz"
  sha256 "f92c431738712f8dc88afdf9b1b8313d57f603910b5545b81675ffd2e5d22166"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "831a1a942721e11c6444e415309c15ab92f5c88baf894fa86f3fbf19f114793a"
    sha256 arm64_monterey: "7400a83f0b6151faa3c3cbfbb3aad6cbebbc88f53372568c1c992e220b1ee3bc"
    sha256 arm64_big_sur:  "742080c2313d9a9bf86c0239d9d2a315aa79f7b60f65f05df110b16c3cf1c669"
    sha256 ventura:        "cbe097938fd7ac50c26b544b3dcdd8dcbfbaaeeececee281ec652c6f5045fcc9"
    sha256 monterey:       "e845a4ff1a18e65bd15e88ca7aa267b5acfecf0bfe602f550730a81553b6cec9"
    sha256 big_sur:        "6dc16958be6de55bbcc6d87a13c1f182637fd67a2a95719a1dbba2a69354fe33"
    sha256 x86_64_linux:   "a32f3e7aaa5f1d06083d84b5a977cac93f3a9feef41fdbee5f372e31ef1850f2"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

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
      system "../configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
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
