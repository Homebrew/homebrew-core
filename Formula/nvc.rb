class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.6.2/nvc-1.6.2.tar.gz"
  sha256 "e6e2db8e086ef0e54e0745b0346e83fbc5664f9c4bda11645843656736382d3c"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "a2b12eab1789c86431f2c2243e07f012f8bc23eb8bdc753cc460e2c548f80e63"
    sha256 arm64_big_sur:  "e2af86fea8247b02a6fae2a9dd6a197f180647950bcbda07a0e7a865054873c5"
    sha256 monterey:       "9c4dbeb21c316cef280370437fe31c6a2d8536ae66bd8f6f13de8303adf4f1fc"
    sha256 big_sur:        "41afd05b5d20c00d5f2051858bbaae4c46c200eed14e25a77916b7072341787c"
    sha256 catalina:       "806ec3dff942acf027597a0c712527ed90d04f732cf111be011bad506fbeb16a"
    sha256 x86_64_linux:   "58200eb93611d5b1ea8efe69f1f7d26e117f8d184c09a39ab9445fef24b17b98"
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
