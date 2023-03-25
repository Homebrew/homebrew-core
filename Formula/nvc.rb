class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/nickg/nvc/releases/download/r1.8.2/nvc-1.8.2.tar.gz"
  sha256 "d2fee04dbf5b08f3f39f535482ecb9d92c0dd09e7fa11588a9e57ac07ee5ef77"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "34c4b550fcb19d2596b214224ae1c97bfa0cf0bc466e9e097a2f9e7b1c6beb21"
    sha256 arm64_monterey: "97cfdca98cb1fffb8c472155d1a206953478d7688af83c8944c20aa695fad350"
    sha256 arm64_big_sur:  "7979834d7dea36670fae20e2cc8bb1bf78c4b569f67f4a650d563d0306811d67"
    sha256 ventura:        "7beec8540b188879225fecc213735506226437bb83e50ea638c1342e417fdd81"
    sha256 monterey:       "baf7cbbb043c5a9556935baee3ea2c00a901b512d96dfdada30a6dfed65ba3c3"
    sha256 big_sur:        "ce9a5f7563cef3cecda8e3df332f4019a08e73424b4ceb8864285bb48c73cd44"
    sha256 x86_64_linux:   "270a62c488bae6c3108e1730259542a25ffa479ae1fe125753c6cd44d2e15533"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@15"

  uses_from_macos "flex" => :build

  fails_with gcc: "5" # LLVM is built with GCC

  resource "homebrew-test" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        revision: "fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b"
  end

  def install
    system "./autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    ENV["ac_cv_path_linker_path"] = "ld" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "../configure", "--with-llvm=#{Formula["llvm@15"].opt_bin}/llvm-config",
                             "--prefix=#{prefix}",
                             "--with-system-cc=#{ENV.cc}",
                             "--disable-silent-rules"
      inreplace ["Makefile", "config.h"], Superenv.shims_path/ENV.cc, ENV.cc
      ENV.deparallelize
      system "make", "V=1"
      system "make", "V=1", "install"
    end
  end

  test do
    resource("homebrew-test").stage testpath
    system bin/"nvc", "-a", testpath/"basic_library/very_common_pkg.vhd"
  end
end
