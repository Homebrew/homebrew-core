class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.7.2/nvc-1.7.2.tar.gz"
  sha256 "37148d03e9b476f824fcee94c864620d1c393c096a4f952e0608c2cb29cd6c4e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "bd9e4f0641615cb37589ae0dde20511f6c03fc25753b76dc97695847df0af45e"
    sha256 arm64_big_sur:  "3a796c73f58595e7db84393a705f56ff0e32348f7b00686744064c0e63195178"
    sha256 monterey:       "879d55a144d743cdd856584f8d591d59ddeee804fd60324ac9e25fded12e3b8b"
    sha256 big_sur:        "5ecd3be53e108b061e4c9193a69e4b9d25adcaccae6f335186ce8308adf7796d"
    sha256 catalina:       "54beba311380216d2e375f3f4d84d414a3d352668098cd4676e393221b66a4b1"
    sha256 x86_64_linux:   "44629c1c97118cc86051714545fea69d0412614db1eccb2a2b57852f19aa6ca2"
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
