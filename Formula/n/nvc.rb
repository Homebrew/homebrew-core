class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.11.1/nvc-1.11.1.tar.gz"
  sha256 "3ff779e4eafc116cec45ee00fe85abab9e2f7581411d06593ee51a88834dd7ad"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "b5b65b9ec5c4fcf20f672864ab79b0342307f6184faee477c3a3c62259dc229f"
    sha256 arm64_ventura:  "48b8af34e2c0d5d592933f5b4f2060add0e152446f5dfa9807903ffdc6ddfad5"
    sha256 arm64_monterey: "03c8b0bd570db96e3578ff34aa11dbd9405f31a3ae7e5b5011a66d93ba1cd752"
    sha256 sonoma:         "7475e62c79910021eb9c783a8d4b4217c68082688e97f07289ccc19320e6f6ce"
    sha256 ventura:        "15b9a15b54abea3bc6184467ed177c27533501cf12659d03ed3f0e84475ee815"
    sha256 monterey:       "53ba10a810a677f144bd2fbfb436f0dbcca462672cf0013c0236bd8b62a2ee26"
    sha256 x86_64_linux:   "ac662fe6deed0619c93468b84da432b350339638ac4027ecb4aa99df625b48b5"
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
