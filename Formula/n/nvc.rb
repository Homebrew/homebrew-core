class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.23.0/nvc-1.23.0.tar.gz"
  sha256 "10dab7ea016d8a2f7c4ea74a438b6c999423007aa69c0568fedb59564440b3e2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "36c32376fd5bdcd0563424acc5f7e3873eba40d23b2041d14cb3b01a100ed1c8"
    sha256 arm64_tahoe:       "1cdfbf6234b0ca5d376fd447a89a97624d696b2d23a7ca5e79b238ba4e886e0c"
    sha256 arm64_sequoia:     "45e00d44410af7c5a52fe64bcd84bf841b0480955c88723a690aac01a5a4d33e"
    sha256 arm64_linux:       "dffe8d466142f69111710c74d6b82728062dac477b89b922c88b633f7abceafc"
    sha256 x86_64_linux:      "19c681428d3229afc4edc87a73769added6e6cb1e71a3e111529090ccd56a274"
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

  def install
    system "./autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    ENV["ac_cv_path_linker_path"] = "ld" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "../configure", "--with-llvm=#{formula_opt_bin("llvm")}/llvm-config",
                             "--disable-silent-rules",
                             *std_configure_args
      args = ["V=1"]
      # Use a two-level namespace for plugins while retaining runtime symbol lookup.
      # TODO: Remove this override when https://github.com/nickg/nvc/issues/1663 is fixed upstream.
      args << "SHLIB_LDFLAGS=-shared -undefined dynamic_lookup -Wl,-no_fixup_chains" if OS.mac?
      system "make", *args
      system "make", *args, "install"
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
