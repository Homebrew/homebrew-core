class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.16.0/nvc-1.16.0.tar.gz"
  sha256 "6848a478907acc28de7f176ff9cc3085ae7b30d3ff82741eaffcc6de49645681"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "8a256c9ff041834ad1aa6e46a0d4c5b73a9d100eaf92998e6ef5df191fb7afbf"
    sha256 arm64_sonoma:  "4c2f1cd536fc6219a36f6e11c84b6a33bb5bb65aef5fef907ebdfbb094524f4f"
    sha256 arm64_ventura: "108b19a91c2be21610fdc95a8ea65954ac452783eab409fdecb0f399248828d8"
    sha256 sonoma:        "ae3bfe68f79a0d0db4ece1ac8b8dcdd1ba92ca73466912444689d7ef9de8a1c5"
    sha256 ventura:       "bcadcf60d9c4147de34def0d3d457b0973fe0046497fcafca5d420de89230b4e"
    sha256 arm64_linux:   "f0ffbdaaa453b34997a84b0d7cd59d349a86b4e18997123507100bc8c95756f9"
    sha256 x86_64_linux:  "c5fa194a80132661082fb4c8803078bb4e0e965f74122678721cf761f3a2e3ca"
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
