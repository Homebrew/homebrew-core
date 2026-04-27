class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.20.1/nvc-1.20.1.tar.gz"
  sha256 "fa077ca6614e8d2c8273e9a721a7c3cf7420ae9619133ab4f3a3872669789885"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "d7c0e4b6eeca553a093fdcb10dd550a0ed3d0f9da8d62e26bf82dd1d23b0fea6"
    sha256 arm64_sequoia: "210f82a153cc20c3af0c1a18d11dca2cc73aa66e6c4db75ff58ba4d4bc7566ea"
    sha256 arm64_sonoma:  "e072f20516f52e032ca0ab073fcd3925f6d0f746fc413a65b6450dd6ebf9fd25"
    sha256 sonoma:        "02e0ce1330743a0eb0732786fe2c687226890657d5676572836d3afabd0a2438"
    sha256 arm64_linux:   "692a0019767b3ba8860165319fe5bd7915f44a225fbdbf376cba28fcf2a3eeb2"
    sha256 x86_64_linux:  "d863fd21c447da9398027f0bc45bc5c658db7f5d80a9f5613b50498d06ce1f48"
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
      system "../configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
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
