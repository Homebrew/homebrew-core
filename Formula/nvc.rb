class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.6.2/nvc-1.6.2.tar.gz"
  sha256 "e6e2db8e086ef0e54e0745b0346e83fbc5664f9c4bda11645843656736382d3c"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "d94444247597cbc17c3e446519777ef98af2f890b4ddec04580aaab124f09fc3"
    sha256 arm64_big_sur:  "b556f95f7dd3ad3fe13600a087c4a9b180a2f0299e6275648cf3af398e423868"
    sha256 monterey:       "978ca721f49f993579acab15ba13ec1a6cd106107cb721d3f25ba4605178b0a3"
    sha256 big_sur:        "85e996f111a1e044b618c3668e8a7e4f90d1199e62b541255a38ffff19220e39"
    sha256 catalina:       "46167192b6dc41d9cc8ebd3f6e2fd51c5733541f83eaed8e53d06f57bdd25bb2"
    sha256 x86_64_linux:   "12c4126806168b0c08fbd201e4b1cadefd2fb0dcafa24927ff11bc4c54826796"
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
