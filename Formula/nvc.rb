class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.2.1/nvc-1.2.1.tar.gz"
  sha256 "ff6b1067a665c6732286239e539ae448a52bb11e9ea193569af1c147d0b4fce0"

  bottle do
    sha256 "23b8d156e8ee517b80e7736eeb31bfa3ac59e30bbdca157b53320b8cf987b633" => :sierra
    sha256 "fec8eab13df57ffec18283f6a83366afcf431640f9e25142a4da04f63e43e2bf" => :el_capitan
    sha256 "f33ffc17ef6123f97750b76fddedbb6ba3865fab02ebbca04c7441631740092d" => :yosemite
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "llvm" => :build
  depends_on "check" => :build

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        :revision => "c112c17f098f13719784df90c277683051b61d05"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./tools/fetch-ieee.sh"
    system "./configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end
