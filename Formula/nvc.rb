class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.5.1/nvc-1.5.1.tar.gz"
  sha256 "2c418a19c60ee91c92865700be53907b8fbfaa3ea64bfc32aed996ed2c55df43"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "89ad43a7f12f4bcc1abbe56e571a374fbfea3601b43d05c5175e191ede8457a6"
    sha256 big_sur:       "b950d81b34fd6ba099b10c85fc96562190bc8af66f0ba5315f10d325c58f547a"
    sha256 catalina:      "37aac62a2eb006671e90730ede9016a1f2282caff5f1bb41f95e4c53cb93e297"
    sha256 mojave:        "4d57ff4df2c881f16e82a57be5af32701729a9cc710e9a7581d688302c3dac72"
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
        revision: "c112c17f098f13719784df90c277683051b61d05"
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
