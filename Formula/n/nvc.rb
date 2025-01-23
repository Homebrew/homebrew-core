class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.15.1/nvc-1.15.1.tar.gz"
  sha256 "66f90dffc9d4fd68ca352afdc20cbb8959c25a50f9041b7a62f0e3e0f4d85c44"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "4e1c0a03249c40dff9f1a87c2c87ea6112fd0f9630987934e57396bd54f04988"
    sha256 arm64_sonoma:  "9bbfec8b454a7358a029f9cea50a6a33307b68f0c1269770feb60260807e51e3"
    sha256 arm64_ventura: "4bf7659c527aef2e40c12a11b16a9019550997b4ec7f50bc24b06788da1784bd"
    sha256 sonoma:        "3b6ff73dfdc54c33eb5c9568a0b5db09fdd07debe76cd17dedd3fc99bb1094ed"
    sha256 ventura:       "14c4132a6775f498109a8a3c2a56d8aa7a0825794bd60d97d054ed6f1ba9b9d2"
    sha256 x86_64_linux:  "fa7526f80ebd4c9792db5ef3a7c3b7aaf5b2ae5971c36e82cb654d9937fa07cb"
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
