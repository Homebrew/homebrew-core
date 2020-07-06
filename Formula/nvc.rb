class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  license "GPL-3.0"
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
    sha256 "fa793a160f27114d00283841aa3b62f84fd96294ab32edec126b2394b2922e17" => :catalina
    sha256 "7956048641f3bb90fedd773aa989ec8539ee4d8e896ebc8df1e9b73a5548a35a" => :mojave
    sha256 "fa79164877d0f31bc605aca1bb2d4fea9f97dc22e83ece3c73b231529dfd4820" => :high_sierra
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
