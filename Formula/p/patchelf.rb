class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.19.3/patchelf-0.19.3.tar.bz2"
  sha256 "20dbe23e9dbc4ad769078a867ad002c04297a069ff93c95fb72242dd55d4dd6f"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f785866740a9c4010ce961214e5fd8734be9369d06d1282adb75da699322799"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5adbf0b87fc96a767414bbed42dd2dac926d6a6340a9148f50835ba727b6660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce4c7e8ae70eb6dca9823a6682be92d3a9caa5d9f0a105991e021b00092f553a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "94c77e6b38123091609f83bdc2d47533335c915d31d935f44c18a85ef7208bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6cc97c2a1de234017bcd54cb3d12ae95b36e3b5be9a0dfb6b5b276879ca7d9cc"
  end

  head do
    url "https://github.com/NixOS/patchelf.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  deny_network_access!

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
