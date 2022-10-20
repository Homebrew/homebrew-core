class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.7.2/nvc-1.7.2.tar.gz"
  sha256 "37148d03e9b476f824fcee94c864620d1c393c096a4f952e0608c2cb29cd6c4e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "641504c3c6c9abcb8e54dca8598adf0dc2dd839758a4eb494be16a8782a0a41b"
    sha256 arm64_big_sur:  "b30be3c8262503c93de5bd55d45512c23532ea43192f5f48069a26c7a8b03d66"
    sha256 monterey:       "3d241eb45e92b2ddc121a00de0e8b589b6c7b9299a0dd9242ff62a41757d14a8"
    sha256 big_sur:        "6d6ffdc873283b2540de59ffad9e416d47db2d152e3d6d2e199dc696921be28b"
    sha256 catalina:       "ecf0c94b5703a52afedb94e816ad96b9f1b0be8212e3e25b91cac9c48742ac98"
    sha256 x86_64_linux:   "fe048c665f32a095959d377d40f6f991e1a6d6f4fac87cc3c371db5d849fadd7"
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
  end

  test do
    resource("homebrew-test").stage testpath
    system bin/"nvc", "-a", testpath/"basic_library/very_common_pkg.vhd"
  end
end
