class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.21.1/nvc-1.21.1.tar.gz"
  sha256 "0481436a52b791cf33e412090c94ffc59bee6d8a6f1a350cf7d00883f155458f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "75bc4820ab4dbcec366ab572dac04f925c79191d98edaba2f74a78a9d3e8720f"
    sha256 arm64_sequoia: "7b2cfd73f780380ea45f43d5ca2b990a165bee045ddded761ee9b67bee2bc473"
    sha256 arm64_sonoma:  "24f1048d2e67078785bde86089850dbb3410dd146b39393333adb066b87f5743"
    sha256 sonoma:        "fca1c07d2798f2389be0e5f7eb2d220d0b4108fcdcba225c00d1b45cf772f21a"
    sha256 arm64_linux:   "9011a1812c6ab80608df6dc6e866d59ae78d966bc2d4af8e4e122c044ff7d532"
    sha256 x86_64_linux:  "3279e96662775f24e5686ef4b3bb4b14a87ca79471a1d6f93ff89ba28b09c49f"
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
