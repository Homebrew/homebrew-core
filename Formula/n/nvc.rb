class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.17.2/nvc-1.17.2.tar.gz"
  sha256 "f330dc736d579df7ab494ff0853fe8929243c4234f7cc4d1e9df55d2ea41fbfb"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "7f174609d6a8d0180ef812a4dba6e9ba6762797cac899637925a3829753e0eea"
    sha256 arm64_sequoia: "ffe3f481135377562a65d45bd8af4be3af0dbfe220c8c0c7518fe7e718bef354"
    sha256 arm64_sonoma:  "cb88c9a86f2e423c2f60a1aba5b9f2b88bf7af8afe97b12974bbd161c17b5cc1"
    sha256 arm64_ventura: "4e2beabf529215fe2ba4b1f79e2d7027dd6134bc939ad6fbbba5232fec668c34"
    sha256 sonoma:        "e17893e769cf188f3aef6e6a7c2fcd192847d66bca4df926629ccbf1dde6ded1"
    sha256 ventura:       "50ad0caa4afe6db5591ac5c32d6d25718030f62efe188c0c121ba65d5024d51d"
    sha256 arm64_linux:   "914f93ec23d9840f826d36c3e160ef66a503ead38b91aafb28c467ea5b9de6e4"
    sha256 x86_64_linux:  "3f363a64f8ea7290cbcf5cda0aa271dff2979cb018e5743a29786bcbd6dfdd6d"
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
