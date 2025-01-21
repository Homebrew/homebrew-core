class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.15.0/nvc-1.15.0.tar.gz"
  sha256 "27aa4a11060bb642f031d96d9e85f3132fbf9ed45819859dcbb811756b1b0cad"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "952f35372de21c8d3fe9ee8db1423a432c0d75d800f6b13341eb4256c27fef95"
    sha256 arm64_sonoma:  "06f6f8f6147b9625df843ae9ec577c7245499a07de8f4d2851a22ba6687ec2e2"
    sha256 arm64_ventura: "120f17c706587055078a32e18d3c9e2db3ea156123b82fbc2366ec333c15a94d"
    sha256 sonoma:        "32b93639c8e8e9497d9029bb3b30a6a229162b5818d11a722c997e1c090f5120"
    sha256 ventura:       "19f06ce0b5e6b26c6e398dc5f6d363c7c2ec19f3ed0755292201d0cfc28f6d21"
    sha256 x86_64_linux:  "56f8c88a1d25981f8f833c9c76837091fb80ca7cd4108cb98130808029a9b355"
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
