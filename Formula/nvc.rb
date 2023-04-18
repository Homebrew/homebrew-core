class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.9.1/nvc-1.9.1.tar.gz"
  sha256 "0767c845ed7f93d29bd9cd9c5e75c788787a3515112a6fb335ed82b6b3d3378c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "bca63ee6a5c0a1cf82822ae1cf7f8f551aab0b7fe2e6fc5a762bd43f445cbb07"
    sha256 arm64_monterey: "93d603260b867a00dac496c6463cc30b722092f745d34bdcd1757a9ccad16da2"
    sha256 arm64_big_sur:  "3ee9313f3c58074a068710f8bbfc0dd85aa57bc494b559895b000ca6a5cbef1f"
    sha256 ventura:        "405cd98ce649b0bb3d5d5a43c46aea7cb7560bd8001b909c7538b821795e2254"
    sha256 monterey:       "10c444fe690af8208d7b4c7e9297b09b7f8315bd54fddfe47ebcac8e6edb0a3b"
    sha256 big_sur:        "a212c4205318c5bc4299fd9e5489f676f62042c1c39b08f54b22467f0cd4870a"
    sha256 x86_64_linux:   "93e558e42d7fa14d19eb0147778d1620cbbc44ea5b683b05814cc4f36ce55023"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "flex" => :build

  fails_with gcc: "5" # LLVM is built with GCC

  resource "homebrew-test" do
    url "https://raw.githubusercontent.com/suoto/vim-hdl-examples/fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b/basic_library/very_common_pkg.vhd"
    sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
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
      inreplace ["Makefile", "config.h"], Superenv.shims_path/ENV.cc, ENV.cc
      ENV.deparallelize
      system "make", "V=1"
      system "make", "V=1", "install"
    end

    (pkgshare/"examples").install "test/regress/wait1.vhd"
  end

  test do
    testpath.install resource("homebrew-test")
    system bin/"nvc", "-a", testpath/"very_common_pkg.vhd"
    system bin/"nvc", "-a", pkgshare/"examples/wait1.vhd", "-e", "wait1", "-r"
  end
end
