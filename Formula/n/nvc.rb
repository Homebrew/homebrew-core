class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.23.1/nvc-1.23.1.tar.gz"
  sha256 "6e3d1551a3fce8087c96daf9bb8a5514be68850f1c4a30a5e05b8ee2be03acdd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "3f02b1685f4025a60c17ae1ec48eb6749bc1b47f190b80d61cf0f2f97d9f845f"
    sha256 arm64_tahoe:       "82433b55e8597004f2bc83802922116c09b36231dc5626db2137d868cab4c3f3"
    sha256 arm64_sequoia:     "e331069b4c5ec9eea363bc619829e865def0c3ca27d4d7cc144613389e5cd657"
    sha256 arm64_linux:       "0fa759d56f04c8b705aed826fc96e4e9329cd6012718d9aa068ebab74b8ae2c7"
    sha256 x86_64_linux:      "d1a2819b90467271bf0b80d565f1d5b7d3b6c3e7073cb7c773ae6e0636667e39"
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

  on_linux do
    depends_on "elfutils"
    depends_on "zlib-ng-compat"
  end

  resource "homebrew-test", :test do
    url "https://raw.githubusercontent.com/suoto/vim-hdl-examples/fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b/basic_library/very_common_pkg.vhd"
    sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
  end

  def install
    system "./autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    ENV["ac_cv_path_linker_path"] = "ld" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "../configure", "--with-llvm=#{formula_opt_bin("llvm")}/llvm-config",
                             "--disable-silent-rules",
                             *std_configure_args
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
