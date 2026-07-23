class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.19.1/patchelf-0.19.1.tar.bz2"
  sha256 "2cce01de93653829f6ab68a20c2ec275e1c00a946110704a27e928d2e6e88716"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a41565145aaa4788879d5365668103f20b0a4d59d4dbd418cbca854d43e50cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f53818518b304c220b5df5cbc15f40ee7ced3e9e5e4d926b0e48cc08d693467d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88cc917662318f3890f42ec3836920f0ab725d9fbd1655974299e6efbcec5473"
    sha256 cellar: :any_skip_relocation, sonoma:        "e549b8d24de2dc84f1c4dfd72bd747a3a2db611adcbfe5466dcd0f10908b9dbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d687a86b519f90ba73aeef58582937596d8dd7f2eec1698df06d050fe0485998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e881ea72d3338780974e10cac8b614c8f099c3ffd99713bd68fb1e7aeae50ce"
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
