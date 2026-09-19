class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.23.0/nvc-1.23.0.tar.gz"
  sha256 "10dab7ea016d8a2f7c4ea74a438b6c999423007aa69c0568fedb59564440b3e2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "ecb7d20decd2c9f716142d8e97136ccac38eac0018a5fc3708844fe3425b12c3"
    sha256 arm64_tahoe:       "e486075d582fb3b05662b0d3b4053e568145ccfa630193484128d72e4bcfbf3d"
    sha256 arm64_sequoia:     "ffb13e65afaafcb83f439742a5766359658ce5c0a857edc07d81a66d855d4727"
    sha256 arm64_sonoma:      "1bd46aa2821cdcc482be6091e09d8b683da054e1069ffb3198223cc64000435d"
    sha256 sonoma:            "9c86d2077d7975fb2c6abd7b185b53266a47e5a29ad7de48434be164364c72f4"
    sha256 arm64_linux:       "f5ea4953cf63dcb730deca3a9c7fa1091dcdf742351ba7d71ad6c3df0c23b6b8"
    sha256 x86_64_linux:      "574fadc94fba04697060ce77c001cd718d02abf028ac4408da566d75643016ef"
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
