class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.18.0/nvc-1.18.0.tar.gz"
  sha256 "02c0aaac59f7277f3151f9ddb7052928b7b7e89c1f77ae2b1c47d55988c64588"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "3da29743c1bf65631eb79838c8e4e07bd49bfe8e89f6db31397a78c191882b30"
    sha256 arm64_sequoia: "9bb96a98ade58b073c497611008168e6bae8870bc1de2b2ed9f263397f716be1"
    sha256 arm64_sonoma:  "4c95c59c4e0022008174857d386c0e77233212633ae7d1cb41f922be7df6a377"
    sha256 sonoma:        "9fc875689a634f2b64cbb63639be72af1ca1c55b277099767082c80175f9d7d0"
    sha256 arm64_linux:   "786e3811a17180d218e6536cd9efeffa8e8a61d1de6da4955998bed9b9c8defa"
    sha256 x86_64_linux:  "e1151a9316391195a40001b50f2dfa0404a5f0dc586346fe24413a1eab00a4f2"
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
