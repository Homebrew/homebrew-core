class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.14.0/nvc-1.14.0.tar.gz"
  sha256 "a0a05124ce3463de37d1d2dec213737e2edecf817673223c7ed5d336b2372ec5"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "e53571c8193e63e0ab8dfe87a44df159eeed5227066176127b798307cd965ded"
    sha256 arm64_sonoma:  "4e865697309fd7f3de796a59ac38375b0e129d110b5ea78748bf9b13e92a0469"
    sha256 arm64_ventura: "e93ee7d60c8390eeeb8cd55d0ae10017db7d08872323cbba53f9ba86438b5649"
    sha256 sonoma:        "fa0e647c2b3a59efd933777eac29f20e65a323cf04c6f65e37cff7ccd6ce1f85"
    sha256 ventura:       "8bc764d27d440bea9f9bd2fd43746e46aa01544f8f2dc51751e9005cff0068c7"
    sha256 x86_64_linux:  "5c426a4331a13bae97a3c5c2c70dca668ea584722879c19cf1b21825b83b36d0"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  on_linux do
    depends_on "elfutils"
  end

  fails_with gcc: "5" # LLVM is built with GCC

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
      inreplace ["Makefile", "config.h"], Superenv.shims_path/ENV.cc, ENV.cc
      ENV.deparallelize
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
