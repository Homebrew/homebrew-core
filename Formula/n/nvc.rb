class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.21.0/nvc-1.21.0.tar.gz"
  sha256 "1667cc194e2cdecfeabe70694915070264720f22ad2c18bde0b46902d2960c24"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "a82d31a827f0c7bfc7d5a408f3782282cfde4c810fde89a6f1eeb6631df1c4bf"
    sha256 arm64_sequoia: "615b3a0e76a1812ad52312bd74a2fb92fa1fe8741ea167cdb1354dc37da401a8"
    sha256 arm64_sonoma:  "cfa8ef31f454eac379fde48288d9a67f7d67fe4ba84dff2185ecc9fe84085a00"
    sha256 sonoma:        "1b35f3242d35c53f029388967d3aa0eb3aa7293065233dd5418fb78e776931d7"
    sha256 arm64_linux:   "af305268ca7933e70d6ee786433b55c52ae32b95a7c2aff6fce450d3a85a35b1"
    sha256 x86_64_linux:  "11ae76b1b133f86f5d1f13e048e2d81e22c2f040f843b32dd4cf6f2d803349e1"
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
      system "../configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                             "--disable-silent-rules",
                             *std_configure_args
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
