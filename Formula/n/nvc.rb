class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.10.2/nvc-1.10.2.tar.gz"
  sha256 "bc162969185bf1732f700bab958bcba0f21a651e3adf00594255773a2e986c32"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "9a2801055498b4f789678fdf20d21ce31fc4476158c78c471bcd66c77a9deb28"
    sha256 arm64_monterey: "8089031c77506476e44adea7028aabd50e663d5f29db93c30c24e6e267f20db1"
    sha256 arm64_big_sur:  "96ee0131d33bd685d77719c9acd47a35ea88c882bc384da26788a5ccd8b4c674"
    sha256 ventura:        "8fb3315ad13753cef209d69049120cee44360e5f0fc12e9ac94835663142d17c"
    sha256 monterey:       "53259e22a20459511c4bc9db95221cf7143f6c4f989c74d75bb4c1be5d5619a6"
    sha256 big_sur:        "933b6c17aad3fde3b4e094b0a033f99556af30575ad86a9cc741cda86510fb8a"
    sha256 x86_64_linux:   "e21561bf7bf9467dc87e434b988a716a13628875edef2e25d6057f3ebcfd6032"
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
