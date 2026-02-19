class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.19.1/nvc-1.19.1.tar.gz"
  sha256 "da882efe5aad3df460dea75ed654f23760fc887414a254e628c35ea4c9aaa731"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "72f2d13e4176a94d5843201de4d0b1199536802494394581d881d6c5e6ec23ef"
    sha256 arm64_sequoia: "d011ccb3ad645e41d7ca685a1ac5e2a5e86826b868d2f17d5060f55490496d28"
    sha256 arm64_sonoma:  "a3355c5b7c3c901dd29aa72041da624e790606354c14396a927ca421aecab1cd"
    sha256 sonoma:        "94bc661fbbaf4df97b7e8fbb51634d505850db193dfc58ddc496c8aaaa0a48ba"
    sha256 arm64_linux:   "8bdf0327df7c93d3e56e3e243fd6fdaccaa434f007f6157a588ad44286a43773"
    sha256 x86_64_linux:  "4c05ca77218b05e6962ec6e66827e5955876b65c26326fe347c029872c3ff3e1"
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
