class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.8.2/nvc-1.8.2.tar.gz"
  sha256 "d2fee04dbf5b08f3f39f535482ecb9d92c0dd09e7fa11588a9e57ac07ee5ef77"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "5f68e0391a3511891db3ef59c5184385849dba5f2c2695eda8a4cdcca2eec5fa"
    sha256 arm64_monterey: "f828b5c7c8655d4ecb71d9e2a3423cfe3a6eb3b3723f58311b1f7f64d72a4ad8"
    sha256 arm64_big_sur:  "849d64610daf8069cc26d4b006df942f1f873858ba21f380a91befcfab255c26"
    sha256 ventura:        "f8910732b41d6d5365bee48f6295f4798256254b3db057d0765dd0a512e6a2bc"
    sha256 monterey:       "3127e8715c0c3807226f38906725a2d84b768f95c4daa659c78a7bc00a67d7d7"
    sha256 big_sur:        "397f1db39543a55d5ebe186f5f8ad73006838e479866e330cd628d8219f8d899"
    sha256 x86_64_linux:   "7d75946e492901bab0c9a8036bdea67edcebcc139121ea2322f776824a3e5f6c"
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
