class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.19.0/patchelf-0.19.0.tar.bz2"
  sha256 "b189d3ec57730757895b9e7d3a1f136d3af96ec9228ae6ef0a07c20a213f28f5"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7981e70859aaa000f427cb4df304efd2f040cf3b2cd30f44b516b067fde7fcae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a3c0beb3bd9c8569bd183c57240a27af1c5bcb26f7d1ddde8cbe39bd1a8937d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01e20a850281a893c3326b841b340ef6512212586dc9bca3c7613f394b452c72"
    sha256 cellar: :any_skip_relocation, sonoma:        "631672f1d3473fa042d0a900132f15e522e962b01343abe25bb162efda0b2ba8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8386c48440b6c227579edab6e018e4073294b934ed731c11f642b5fe09851da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5bc076abb6bf1b50cfe0d30db36f39f14d1712fdf5099c01a6048a198379a65"
  end

  head do
    url "https://github.com/NixOS/patchelf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    if OS.linux?
      # Fix ld.so path and rpath
      # see https://github.com/Homebrew/linuxbrew-core/pull/20548#issuecomment-672061606
      ENV["HOMEBREW_DYNAMIC_LINKER"] = File.readlink("#{HOMEBREW_PREFIX}/lib/ld.so")
      ENV["HOMEBREW_RPATH_PATHS"] = nil
    end

    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    cp test_fixtures("elf/hello"), testpath
    assert_equal "/lib64/ld-linux-x86-64.so.2\n", shell_output("#{bin}/patchelf --print-interpreter hello")
    assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed hello")
    assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath hello")
    assert_empty shell_output("#{bin}/patchelf --set-rpath /usr/local/lib hello")
    assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath hello")
  end
end
