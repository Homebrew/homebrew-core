class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  revision 1

  stable do
    url "https://github.com/nickg/nvc/releases/download/r1.4.0/nvc-1.4.0.tar.gz"
    sha256 "1a874bde284408c137a93b22f8f12b5b8c3368cefe30f3a5458ccdeffa0c6ad6"
    # Upstream issue, only fix on master branch
    # at the end of installation, nvc tries to donwload from IEEE,
    # however the IEEE website changes the download path
    # this patch fixes this issue
    patch do
      url "https://github.com/nickg/nvc/commit/db4565c33f7effcab4c8b886d664398a85b653f6.patch?full_index=1"
      sha256 "41a7de8c78730cbf674246abdc3e824ba26723db963536cb019ed9deb77dc0a3"
    end
  end

  bottle do
    sha256 "b80db7d1bf860cf294e21504ca5016949379eb09f5e91f2ada221f7c93e0a470" => :mojave
    sha256 "b7652f61cc91018c76c1c3ca245125b9a1bd13aacf0f7e3791d62748a0af89c8" => :high_sierra
    sha256 "baeed30af5a9e5dfe7dd8c5fdddb7b731912bbfb99f32127e30ae9c366bb8215" => :sierra
    sha256 "e5a6b787e66d0b9e599a86d8e780e81c7aa9ca9240e1ab8446b471e044f9b0b1" => :el_capitan
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  # llvm 8+ is not supported https://github.com/nickg/nvc/commit/c3d1ae5700cfba6070293ad1bb5a6c198c631195
  # and llvm 7 has issue on stable https://github.com/nickg/nvc/commit/dfd5606a182e00d5f7a9e28902234b374c7b2863
  depends_on "llvm@6"

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        :revision => "c112c17f098f13719784df90c277683051b61d05"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./tools/fetch-ieee.sh"
    system "./configure", "--with-llvm=#{Formula["llvm@6"].opt_bin}/llvm-config",
                          "--prefix=#{prefix}",
                          "--with-system-cc=/usr/bin/clang"
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end
