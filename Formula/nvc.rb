class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.5.2/nvc-1.5.2.tar.gz"
  sha256 "56b71a091d9bebeaca28e2cffb1546de91068de8788d96a92d209cec7402349c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "ed81b83101417314e47d4c9e27c1efc2cd5aa8b2f6d360d16ff4ff4a39693dd7"
    sha256 big_sur:       "878fc444b7f6694cbb12ec4d1f6e644d1c7f853d109915ab49c5e77b151100ee"
    sha256 catalina:      "fe88883631d30f010b06fc8c7ff7f5ae7cd8a67cdcde8e28f262ad4f1fcb3e29"
    sha256 mojave:        "5d42447afee153063a563b0b32d8d2a98c955aff3860bbbe30d994d8c82f4dac"
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        revision: "fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b"
  end

  # remove in next release
  patch do
    url "https://github.com/nickg/nvc/commit/64c2521260e868224ed94e6913f378c306ef2909.patch?full_index=1"
    sha256 "3bdb4770df20751079d7c6899a7546cfe43c4a3b56387d5a6188ecd7617bb23a"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                          "--prefix=#{prefix}",
                          "--with-system-cc=/usr/bin/clang",
                          "--enable-vhpi"
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end
