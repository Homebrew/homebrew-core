class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.20.0/nvc-1.20.0.tar.gz"
  sha256 "10913d2f37a652b9b8279cda795c79a70a2b0998b6407e8afbae8e1c805f3b15"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "610cb4caad6ba7c3a103d2a29f8e32424ceb7ae67def0ecac0d656790476b41e"
    sha256 arm64_sequoia: "d7b1b2e32723835801423a6a1566afd7da81b227466ccaf71fc9839bea2e799a"
    sha256 arm64_sonoma:  "b9a3a84085f70804127c5f7d28afc1d160ff6d0b4aff23edef86bb0237b6122a"
    sha256 sonoma:        "37807f478eecf08b5aa540f7f6be1075941cdfa80ea9b8fb2603a8769efa7ed4"
    sha256 arm64_linux:   "752e9bf0ec75a775376a7769a1d8087235826c136cf34a7b82e59e16f8f1085b"
    sha256 x86_64_linux:  "79276b10482c01209a1e7716587dbe4dceb3ae6d978d24af3afa32b6b0cb8aff"
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
