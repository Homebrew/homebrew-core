class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.9.2/nvc-1.9.2.tar.gz"
  sha256 "9663ed1d9373377ce1046d32ecaad9e256b6e9bcabd07440c8133a32128962e9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "d7d43166d1d1e7ce5ea8dfc583fd094a7ef84755c4b7d7bff0fc8b660c7b8151"
    sha256 arm64_monterey: "57ba1110928e5e8e512143bc76700fc5a677fdd6415d99e1c9fe407537bc2b70"
    sha256 arm64_big_sur:  "9a90a86fc06aeb22f1c9127bb1db3ea07ea2028d9515e0c3e3b4683244cdf902"
    sha256 ventura:        "11a3bd0e00906435eeb664d69b04c588cb1fefac2b59875c98c03065a242592d"
    sha256 monterey:       "9f069c00f4b088105b176fe0a7dc9166409e19bf91df6560f9ef8e212bcbb2ae"
    sha256 big_sur:        "188bff3657e4354ed73ce2b26a9a9f47aef3134e55768dacd584eeaa03942f83"
    sha256 x86_64_linux:   "f288ff0836c78bdbcf16bafdee2be95c2487e238d4c292138aa53b9e8f473406"
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
    url "https://raw.githubusercontent.com/suoto/vim-hdl-examples/fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b/basic_library/very_common_pkg.vhd"
    sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
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

    (pkgshare/"examples").install "test/regress/wait1.vhd"
  end

  test do
    testpath.install resource("homebrew-test")
    system bin/"nvc", "-a", testpath/"very_common_pkg.vhd"
    system bin/"nvc", "-a", pkgshare/"examples/wait1.vhd", "-e", "wait1", "-r"
  end
end
