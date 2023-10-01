class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/nickg/nvc/releases/download/r1.10.3/nvc-1.10.3.tar.gz"
  sha256 "b5e6cdc6f62a1496e652cfd571f40d6112277e8a9b077690a21d54015562f64e"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "d0d7971301f9be2b2c6f6e2432bdb3e59230ced7ebc20e13c6406c4b9ac386fa"
    sha256 arm64_ventura:  "2f568a87ec6f689427b32a8d1bbff6717ae0fbf91d07880407e2688caf11ce55"
    sha256 arm64_monterey: "90389cd5f754ad2bc53d75c4787fdb360e5b95426fa212e776898f39cc8e4bd3"
    sha256 arm64_big_sur:  "fe9523056acf0d58eb2879623f56789812d2308998e4c17fdbaf19e35356c8f5"
    sha256 sonoma:         "fb2188e53e6764ffe09e85df5a00f2fa93a74c35a28beec3e868d70abe5a7532"
    sha256 ventura:        "a9ae0406ca50f65910baf3c13a5a751465b3165a5881cc8f9bf38b0e735d5e46"
    sha256 monterey:       "3107eb0b0eca3f27ddc380bfea7a0d9b2413eb8f93b644151353d4efd6f92a04"
    sha256 big_sur:        "7b1b28fd1bae8818a7a2ebcd87d247b159808763f8216a1dc03628ddd0806c3d"
    sha256 x86_64_linux:   "f57ac9bc1f83f4ce30e839d5e9d329912222d90c5dd7c72588bd697fa7f241b2"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@16"

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
      system "../configure", "--with-llvm=#{Formula["llvm@16"].opt_bin}/llvm-config",
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
