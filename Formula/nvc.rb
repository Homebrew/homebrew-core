class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.7.1/nvc-1.7.1.tar.gz"
  sha256 "c800bbe70be4210326020afc873252ff93354739085c1064dc65ebb93722943d"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "47f4565675ba508d16b63a1bf59765ace9a92cdd2efbe78e2efea097b5787b63"
    sha256 arm64_big_sur:  "fe26f9e3111fbe819388721317e00916a03595a4e5b4c04341e13b0eee5e016c"
    sha256 monterey:       "83748aae1ad1bf2b464baf7d0b0ff14e78cfd19d4a4d05e835d2b3dae4521c9a"
    sha256 big_sur:        "a1337d00b56e1c7ff0e6e68ada6118995f63d59d38771ddd3e81f409ebd44d07"
    sha256 catalina:       "0b9d4d69a5846df688cf2952b0148d0fdd17959846c6bbe0de8bf81b73cd0dba"
    sha256 x86_64_linux:   "f8cdac2e2da7c03f212718cf184aa627eceb2113dea1d02a6b6f1c1a4aa49df1"
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
    url "https://github.com/suoto/vim-hdl-examples.git",
        revision: "fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b"
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
  end

  test do
    resource("homebrew-test").stage testpath
    system bin/"nvc", "-a", testpath/"basic_library/very_common_pkg.vhd"
  end
end
