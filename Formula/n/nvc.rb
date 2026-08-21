class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.22.1/nvc-1.22.1.tar.gz"
  sha256 "8cde9a11603dc512e40f12a349a1d3b1bef4a6fdcec9bf0ab0f790899390c56f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "10e9944935e8c9bb75a34dd506b2f0bc8b4b4f7e84353ac481b0a1bcfccb23ce"
    sha256 arm64_sequoia: "728d3c64f2ea109064fd4084a39d381c9466cd7d9325020de52b947f1c38a416"
    sha256 arm64_sonoma:  "ae0c9e6d5eccd74a83bf94d8482ef9826a49fb0f7e657b4e55e41c4cc14b1ad8"
    sha256 sonoma:        "9a3fc63f1775524454cc69845b1c2cd880af9897d766b345066a965c5b6c7c08"
    sha256 arm64_linux:   "3e86ea0ed8ca32248c1e1141606c27364508df4f257d10b099009e6f8cafa102"
    sha256 x86_64_linux:  "613f585343a5789e9a73bcd3bbeb3c22998eedd1b181f0eb8794f850eb795f2f"
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
