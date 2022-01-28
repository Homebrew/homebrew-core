class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.6.0/nvc-1.6.0.tar.gz"
  sha256 "1e93e461b53261254b123ed0a88ba72316ed61d9985bb4439a473bd08b81da88"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "c8443bb8a6e8507928caee878fbfc6b3d81066f2367f23b7e2a0a850b2e2a05d"
    sha256 arm64_big_sur:  "d885152a1fa7e6fc323570499b5bdf559129f40d8b1e358d2a34c2cf30dc2174"
    sha256 monterey:       "ead7036621f66ae97fca966b50439d89b8226eb518c9aad83152222dc6d86e08"
    sha256 big_sur:        "a851a0c58fff15af6d04072921df0b04c541b05d9ef5e2e1f87b7225ddc4ed71"
    sha256 catalina:       "3247453098e6c2f1fde5bc9f9dc1809205465e895049567c941c1ff5747847dc"
    sha256 x86_64_linux:   "c5a6d4059ad6b4a304f513eb2df6840431b1207ad65e0619c54d66e0d3d1c126"
  end

  head do
    url "https://github.com/nickg/nvc.git"

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
    inreplace "configure", "\\\"$linker_path\\\"", "\\\"ld\\\"" if OS.linux?
    system "./configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                          "--prefix=#{prefix}",
                          "--with-system-cc=#{ENV.cc}",
                          "--enable-vhpi",
                          "--disable-silent-rules"
    ENV.deparallelize
    system "make", "V=1"
    system "make", "V=1", "install"
  end

  test do
    resource("homebrew-test").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end
