class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.13.2/nvc-1.13.2.tar.gz"
  sha256 "543c7d0ab753313f6a0c9ffabd6dfd89cc9e6ba04f7fe4f18cb7b93cc24e1612"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "1d4fceb55fad75f5bce5b8bc3990cf26f40b67d1dcb1a1cdacf76b3abc0ef99f"
    sha256 arm64_ventura:  "38d4d817135baea89baecb26ed328b5793089f3365a795904b7ac76088bab598"
    sha256 arm64_monterey: "2273c90c16d977f939a7d68ed0246c1ad78456b0f7dd4324cc4a3b3056e06ac0"
    sha256 sonoma:         "f58cb60b648058c5a0671eaf46f59e48d0f381abd5eb8632f028d09cc65bd9fe"
    sha256 ventura:        "23a966a026049e538bacc3c6df94a9f1b1c6e6dabd5417f9da6d6d90d8599f0f"
    sha256 monterey:       "6cd55cdebded10395315a8905d0beb6662d7d4d627885d5ccbc25450902f8f4b"
    sha256 x86_64_linux:   "34199ab786300eeb669a261c0f5453dd83ea090de8600fe2746f5bfd374ed5da"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  fails_with gcc: "5" # LLVM is built with GCC

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
    resource "homebrew-test" do
      url "https://raw.githubusercontent.com/suoto/vim-hdl-examples/fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b/basic_library/very_common_pkg.vhd"
      sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
    end

    testpath.install resource("homebrew-test")
    system bin/"nvc", "-a", testpath/"very_common_pkg.vhd"
    system bin/"nvc", "-a", pkgshare/"examples/wait1.vhd", "-e", "wait1", "-r"
  end
end
