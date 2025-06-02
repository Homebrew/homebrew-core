class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.16.1/nvc-1.16.1.tar.gz"
  sha256 "47e5a62bf5919829075a18b86d0506b5329d049709bd2e939a7b2814b36b9cce"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "f212f790b7773755f193f24309fc295d5fcee3dc5e7d322a02dd2a9cc512b688"
    sha256 arm64_sonoma:  "58b27a43bf6abf5bca361454b7acacc98d692f589417903460fae04518a0ba22"
    sha256 arm64_ventura: "5af45da380fc4ad9fef063638679e6734cd5b8ba0616921d1575d20072aa194c"
    sha256 sonoma:        "29f01531b9fc6f54fe496b6c39670adc5f8e1e3d8ea20941d35b44ca97fba775"
    sha256 ventura:       "a152b8ae5366828795c883149cbb26f9b5e72302a7aef6d52cc6937b8e63d32d"
    sha256 arm64_linux:   "75f2f85a60c9f5019228e0819269ad752416a05bdc10096a6f5e6369a38e6aac"
    sha256 x86_64_linux:  "efb90d8fb00572e94e752e2d257bd11bf99e337bb053fccb2bcdee2187bcade7"
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
