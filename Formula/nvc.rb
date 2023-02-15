class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.8.2/nvc-1.8.2.tar.gz"
  sha256 "d2fee04dbf5b08f3f39f535482ecb9d92c0dd09e7fa11588a9e57ac07ee5ef77"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "562a603b5c3d40a5fcaaab0d8dfe92b801b1e0dba8ac044ec1b5b421ba8c83e2"
    sha256 arm64_monterey: "0a1bb9a89dfeef7463721305573a1a96b4892b6cafce1ef8bc0b9abe74504a11"
    sha256 arm64_big_sur:  "6d6ff7e96d1ada7cd02483d597ac744b826a93915f3eba3f35e683ffaf33c0d8"
    sha256 ventura:        "a4cbec5893ac41b62cdda2314858b9e3472ed80ffc55f8161f70b5febafe461d"
    sha256 monterey:       "b88d95e98d8080e3ffe1bfa3b80eff7e32e0c582d41f2bdc9012167e2f8935d1"
    sha256 big_sur:        "44a002be25b8a54da6365da53addbe0a6a3c0bf99a5e2899040c66bd23c54c54"
    sha256 x86_64_linux:   "c94a25bf2eb4e66d4f0f2cbabdf72d07aa75c110c5284f72a0e55c0338ddb82d"
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
    url "https://github.com/suoto/vim-hdl-examples.git",
        revision: "fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b"
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
  end

  test do
    resource("homebrew-test").stage testpath
    system bin/"nvc", "-a", testpath/"basic_library/very_common_pkg.vhd"
  end
end
