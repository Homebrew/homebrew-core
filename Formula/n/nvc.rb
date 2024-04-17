class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.12.0/nvc-1.12.0.tar.gz"
  sha256 "68d43db9cdfdfad3cf5a45fa08ed20900733c9f3799117f8f5e10744af79136f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "af2b89cc01b4a3291bab11f99d83826e8790bc12e23e01cc2585caf5fab8d594"
    sha256 arm64_ventura:  "facc28573de5f2f8572bb34d5e0ea0018cfb26284f344f4aa49a7406aee20865"
    sha256 arm64_monterey: "faf7efa6a949725cbf1ada0368b47153a9105fbe82e11ee38fe19ed8f2fd3f9b"
    sha256 sonoma:         "bdc8caced178728dd06732835664d2d9d5075c7e4145059be9fb84c124a624f7"
    sha256 ventura:        "17ae3c79b5b67e9151a152b39e1fe51ab395e27cb02b65d513b543a135682cdc"
    sha256 monterey:       "c40c0e38f68aa5fafddec7ab937260d3c3e6727d723eb0bd45dda26a7524b8fd"
    sha256 x86_64_linux:   "baf0658e908d412a42fc349d431f2cbc326fb991ed67037f17bef3e507743255"
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
