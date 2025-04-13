class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.15.2/nvc-1.15.2.tar.gz"
  sha256 "d3d2ce61e4d31806ebed91dcff7580a9bb16bd0722f3ef86c275c03d999b18b8"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "6140cea270a9d18242c5c85ce2539c72d8fb54d660f4cd42f3c66828d643a887"
    sha256 arm64_sonoma:  "ffcc3a5ca1ec7f92a27c013ad986a9f1b636543727197975162b2cc3e68bd3c4"
    sha256 arm64_ventura: "eae4c7a244d7b7e1c00d3b55ea49d6dfd30a6748dc32b96876027fd873eec996"
    sha256 sonoma:        "3fb503359b5c85ed143a61d67864c128c5a618088fca6c232354c0c67b624a7b"
    sha256 ventura:       "98cc71fde5e39174819fa6b15f34007f4bd0e94a568219f1292701f88469e9aa"
    sha256 arm64_linux:   "071c78c3aba9c8803524d0d603061a0fbcc6fca17e6823f1bd0416e3e5e2ad6e"
    sha256 x86_64_linux:  "cc8330c5951afcfb7938f8841ac13fb9a9a3eb03df3b32aaa9bb916f41aa1f95"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkgconf" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
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
      system "make", "V=1"
      system "make", "V=1", "install"
    end

    (pkgshare/"examples").install "test/regress/wait1.vhd"
  end

  test do
    resource "homebrew-test" do
      url "https://raw.githubusercontent.com/suoto/vim-hdl-examples/fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b/basic_library/very_common_pkg.vhd"
      sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
    end

    testpath.install resource("homebrew-test")
    system bin/"nvc", "-a", testpath/"very_common_pkg.vhd"
    system bin/"nvc", "-a", pkgshare/"examples/wait1.vhd", "-e", "wait1", "-r"
  end
end
