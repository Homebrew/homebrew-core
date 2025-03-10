class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.15.2/nvc-1.15.2.tar.gz"
  sha256 "d3d2ce61e4d31806ebed91dcff7580a9bb16bd0722f3ef86c275c03d999b18b8"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "d053cd65a3ce4fb753e934c8703e9022dc8b14fe12921df2ba852005976b277c"
    sha256 arm64_sonoma:  "36f732ec3c199cb1ac3a8ca99a6320eb8f6d7232eb82706f552f83b6827c83df"
    sha256 arm64_ventura: "a5c06f732ecb301e15599cc9f65e825de897f16281eab045ab962014c907765b"
    sha256 sonoma:        "03ab0790efcfddd402060e14711710b8e59f57b9f27877cbbcf5e7ac375b670d"
    sha256 ventura:       "2460f90690933a675b46fd1e4561c8c0fc503ef063ce10312e01b5217fbf6d12"
    sha256 x86_64_linux:  "b6bd3c7be7d6a61e581af464f4db39b4800de127cb6186e5d3eeec0472609fa5"
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
