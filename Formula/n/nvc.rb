class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.17.2/nvc-1.17.2.tar.gz"
  sha256 "f330dc736d579df7ab494ff0853fe8929243c4234f7cc4d1e9df55d2ea41fbfb"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "87e7db44ec8aafac1756149821faae990bcc3e5282e5a59239ba6c93c6dfeeb7"
    sha256 arm64_sonoma:  "dad7c6e2513f0c2ddbbf34bd9968e259268948ddbeec50feeb4c55a75d5f32c8"
    sha256 arm64_ventura: "59b116f5a664999e6fae8e65a540722e141faa6c44eee835912d2f31e862c299"
    sha256 sonoma:        "7eaff9acd04f346146bf316462bd36550a714894ed6b221525508d5ee761230e"
    sha256 ventura:       "eadea20f436907344dd4d3d3eccbe2ab863e120987f57074290a83d45b654fc4"
    sha256 arm64_linux:   "8f1fd6a1a2b8e7db8a98426e6cad67b18985cd9929ab39689895b77fb740f1c7"
    sha256 x86_64_linux:  "eb1ace5559bf2c5ddb72403203bff511afc53ce2d60dff1d5e9751ef49667d66"
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
