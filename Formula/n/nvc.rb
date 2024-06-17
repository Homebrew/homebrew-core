class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.12.2/nvc-1.12.2.tar.gz"
  sha256 "154a9b2b2647c5b59755be7d77ab4bc95b6b3a9e3e56546e9bbcd14fa79d185e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "395e43e744b30dcbbd0abcd6689c71563d3688d7c0134438ab125d168628d4b1"
    sha256 arm64_ventura:  "5a65869de4b588c391ec074a3af3e5f2c646d472a7d51365a278399a246e82e3"
    sha256 arm64_monterey: "c872484dced4c33b0df7b11760488de60e84c520a2a1f8147d403729b872daf7"
    sha256 sonoma:         "7f29959cd3eff8faeece6e7b75b9b813f6715b7b41b0abbffe7791f0fa92e2c6"
    sha256 ventura:        "2816a9758e4776d869fb86e03d93a19421a78b60205751bc63896942be05a53b"
    sha256 monterey:       "4855b6ec8e1a631ce4d4db731c9f56fba343e42d6d8f7ebee3f9651ff6a0d348"
    sha256 x86_64_linux:   "355c0ec7479cea48b95c595d942e39f4d6d889caffb7e89d3a9c88bf0272f37a"
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
