class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.22.0/nvc-1.22.0.tar.gz"
  sha256 "bd648d236145da472be91fe8ef2b201958ff6f65a75b92c8c97f23ac1a2c980c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "890b1579103d6ebdc5c1a756c162c5a077183a9af8dd64968f7d08c9c60dc27e"
    sha256 arm64_sequoia: "05be009111aac989a73ca08b6730953c321d5a2921bca23cac2cd82b163274f6"
    sha256 arm64_sonoma:  "14826b34a0d490b586bad943ed14593af78c885e7f38a02f26746b1b0289852b"
    sha256 sonoma:        "0137c8496f5e13b43400ce4d378fc1159666ad83de18720e6649bd3170190263"
    sha256 arm64_linux:   "0ef945b662d7722ec1f65fcce602e611dc2a7d032e2774d0dbfb4aebb63c638b"
    sha256 x86_64_linux:  "ff8095269f395e0674ef6bc8fc78e707501a459da22044840ede2af1c2df056e"
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
