class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.17.0/nvc-1.17.0.tar.gz"
  sha256 "8c551c15f283c6a47570883e41b7c3846a4af93e08e6dc82e96dcaf9010c2305"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "337d3ca644c4da8458130b82711cb8671cfac3c61ae0c524ae1bc7a332ffb43d"
    sha256 arm64_sonoma:  "713c88274d51e83bb3d309757022a1ef9f6b2baef48fa4ec16c987fbd7cf262f"
    sha256 arm64_ventura: "4844507aa80fc1d05a4676c18c5c45b623258a89adf0892e076651f5dba51f4f"
    sha256 sonoma:        "c53bda7c74b6a9da84d5bafa7bbcde3f586972a497be85eda737eb4260a19881"
    sha256 ventura:       "8b4ff4db08adfc24cabe4ba0b694aaa46c3036025e063456fe5849d847c9fdc4"
    sha256 arm64_linux:   "307551f1b411d98d35c06025cfcd01d6c8565ae4fcb81963adc2bd745c029b27"
    sha256 x86_64_linux:  "0181713313d8c60d0d8fc9fd77b55e9bd306496c1db1354a3c88cea484da6d4b"
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

  # Fix to arm build error, remove in next release
  patch do
    url "https://github.com/nickg/nvc/commit/4a94efdb8f314732d59368ade364d2e03b424e14.patch?full_index=1"
    sha256 "714b54403a494ec85c340bdf9b371957288c43f3b49dcf4fb5817dcd6d6a581a"
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
