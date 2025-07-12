class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.17.0/nvc-1.17.0.tar.gz"
  sha256 "8c551c15f283c6a47570883e41b7c3846a4af93e08e6dc82e96dcaf9010c2305"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "013920bd5bab3a7e5d0dee3f7ddbd4be3e1aac048862b163b8d882a85dfc7f5f"
    sha256 arm64_sonoma:  "042b8549da4921b6a08c7668bb1a44b95f4ba6f3fa2d49ed8a36bb8de59b2e80"
    sha256 arm64_ventura: "155939777e55c93b725c97403eaa45f097a8ca33e2a7eda9e699611159356265"
    sha256 sonoma:        "9fa4b4a9573a09fac6425509c6a36e8ac94d75744d2e364eb49b44fef90cd566"
    sha256 ventura:       "20047d4d401064bada88e769373a2715f47e58ab4059339b61013bbbf61bced6"
    sha256 arm64_linux:   "c4758adce047815504a0e641718a71b767c8652f39549bf063f92a124f206a70"
    sha256 x86_64_linux:  "f060b8ed624979de84aafc0b1575f67ac4d2f26f209b3ed7fa85423a96eaadfd"
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
