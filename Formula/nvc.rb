class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.6.2/nvc-1.6.2.tar.gz"
  sha256 "e6e2db8e086ef0e54e0745b0346e83fbc5664f9c4bda11645843656736382d3c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "018608bfd3bebece7e5f5af5e71f1fdc49a5e551ee3202f85772fb95d734e692"
    sha256 arm64_big_sur:  "6eb178d6b617aafe7992943730cf697e4b2634a335f209644e789e183a9a4337"
    sha256 monterey:       "57b66b4450bac6e24fa778812f085ae66bb31cee339ad8a218399880b2139d37"
    sha256 big_sur:        "8cc7631d16d716f1072e4636bac84f972503cd4e2af1245843fa52f9a86942a8"
    sha256 catalina:       "3918cf90bfe1581ee3224891fa3d8437741a3209b92690036670a42f5b7d8d0f"
    sha256 x86_64_linux:   "59564f4fa3dec44747ee7c5bd44e7406bea7ad7cce46053214af7791a41e26b6"
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
    if build.head? && OS.linux?
      inreplace "configure", "#define LINKER_PATH \\\"$linker_path\\\"", "#define LINKER_PATH \\\"ld\\\""
    elsif OS.linux?
      inreplace "configure", "#define LINKER_PATH \"$linker_path\"", "#define LINKER_PATH \"ld\""
    end

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
