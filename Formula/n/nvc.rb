class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://github.com/nickg/nvc/releases/download/r1.10.4/nvc-1.10.4.tar.gz"
  sha256 "d4e2baf58b80a45cdfa5ca07b4c9648e438bdbc2b3f3ebeedb65426045fd27db"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "09e5514068ac04ca1e66fcbd17d77cf998adc66ab812e9486f10dd1063f38d8d"
    sha256 arm64_ventura:  "16137d3e239ddaef7cdd31ee2a58e5c3f1fed5d4b7fb2efead23655e6b31cad1"
    sha256 arm64_monterey: "52e4c56436c8d73280ab5ecb4b54136f94d21142d58b37e5f319a15ce7555637"
    sha256 sonoma:         "f78a91c365b78a9cd574f2c0bde86e8fa07635b69a759a4db82e4ae442157d59"
    sha256 ventura:        "48634cb30a0c554fd5709e185d96cbc53a3c53516c9e5112d1f023ac30d2d6f6"
    sha256 monterey:       "5c1ec8d5fab5f06d20bc4f9a9435210ad59d234462cd7c811b464b38b5bacb8c"
    sha256 x86_64_linux:   "ee20d3c7b6a3384e2173f2ec21d6cf6c09bb88c1f4c76e3c5e924237b813f124"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm@16"

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
      system "../configure", "--with-llvm=#{Formula["llvm@16"].opt_bin}/llvm-config",
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
