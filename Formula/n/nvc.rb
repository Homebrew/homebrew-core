class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.12.1/nvc-1.12.1.tar.gz"
  sha256 "90c241596f4a9dab2da86d4350b0b52a5ff170f6ae6ea3c604208c0a21c03021"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "04ae3ecf61b776e1640ad729dac80a7fb13e27c48fad3f3c3d49c5ff7812b0b9"
    sha256 arm64_ventura:  "80f19764e7609876b2c69a76429811f27aaf0c98819643f8327f9f432c988680"
    sha256 arm64_monterey: "0a5c2de52435abef84ece221d2aebd8fd96d5057736b33c27f88cca30880d337"
    sha256 sonoma:         "a4edb2ee61807b786d420c78e058bb37325c851e65bd9ffb4f907fecdd1a7ce4"
    sha256 ventura:        "7b1bd65616b4618478f9a8f9df8947406047fa77d19556d6733eeadc2cc3fe62"
    sha256 monterey:       "1cbe3f5fd6a09a988ed1eac5ed1862aab912d1236ef65329ef2d73e34e5bf0fd"
    sha256 x86_64_linux:   "bc914eb8268b78c79f45d774a6081c26fcfedd869a8f418267a58354f52efe73"
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
