class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.18.2/nvc-1.18.2.tar.gz"
  sha256 "ee34522a04c49f2a73ff4367088ded9674d726b44fd480995df8ac90e84271d8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "a0756adf6b89227b51de8bcbcd882b6286c20e13cc0e27b6912c3e187cee4d65"
    sha256 arm64_sequoia: "6457a0b277fac9d8c91c731b295af597ca875a2bd6167ead38282b87edd50728"
    sha256 arm64_sonoma:  "e4495c0578dd1f4846d227ec3daa80d0c56cab9bc1db9404c93dc0e4844d1493"
    sha256 sonoma:        "9871f7d205fd1bdff03600b3a67eafd0f40c4ebe4ec04ea064b3d3dce5c040b8"
    sha256 arm64_linux:   "97ce5f8fe1b75a0f9e2e4135470d444526f7d2dce9b4a72c48149c02853d0846"
    sha256 x86_64_linux:  "8ec58e009abd9993be09f5a8e78c5912076faac02e385b4dc50381a0e5277ce5"
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
