class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.11.3/nvc-1.11.3.tar.gz"
  sha256 "0004d29681063720b356318c586d5ec85f9c807b7d012c5e32c202b0b682f3ec"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "e78f2e2fb1e1771743f76e3097f7dbd654839200b4ae1f34096e501df9b6b9e7"
    sha256 arm64_ventura:  "d3ca94c31f7adb6377741854041a50f1ab00a635353af915363460036d538894"
    sha256 arm64_monterey: "6bc769647ab32cbc6b47286f77f29801ade071bd7b0d870135803df3a6ae6071"
    sha256 sonoma:         "85b5dbd1f313583c8569c3697fbc539da8cdd0b16fef9dfb97b93faeb7ff4051"
    sha256 ventura:        "c648f49712ba3edde537f248538943c0fa091a0046bab34a309e2e9cc10d2753"
    sha256 monterey:       "41f7ac69b72fea0d3e1739c74f4c31dd39768e037b54a31628b23002c4cb1f5a"
    sha256 x86_64_linux:   "36ddfc72cc7a2c8bbc4cd599ec3cbabaf5b8774461eb6953c8540114de8a346a"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@17"

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
      system "../configure", "--with-llvm=#{Formula["llvm@17"].opt_bin}/llvm-config",
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
