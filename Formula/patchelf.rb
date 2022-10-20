class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.15.0/patchelf-0.15.0.tar.bz2"
  sha256 "f4036d3ee4d8e228dec1befff0f6e46d8a40e9e570e0068e39d77e62e2c8bdc2"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/NixOS/patchelf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "532f4ce03bc98cb3bf22bbe10e351501dbe5960256066478256e2e1bb8035685"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0bf5604d7868fe19329ac4666d268052bc0fd6f16a39183c7b03f164e797d42"
    sha256 cellar: :any_skip_relocation, monterey:       "d9d256f834dbdd935acf2fa6596b362ea7691d1d88a7c45527abf51f8887c269"
    sha256 cellar: :any_skip_relocation, big_sur:        "19fae5315b3100eed3084f1f986cd0e26fe3108ae38c33a274ecb380cbc9adae"
    sha256 cellar: :any_skip_relocation, catalina:       "87aaca01e89114091a518b011e7ac9b0aade4280fac1d69e41b157941b1291a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2620e1de8a1d1242fb6521c434572c98803bd5a97964447f63f80b36280c4a5"
  end

  fails_with gcc: "5" # Needs std::optional

  resource "homebrew-helloworld" do
    url "http://timelessname.com/elfbin/helloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  def install
    if OS.linux?
      # Fix ld.so path and rpath
      # see https://github.com/Homebrew/linuxbrew-core/pull/20548#issuecomment-672061606
      ENV["HOMEBREW_DYNAMIC_LINKER"] = File.readlink("#{HOMEBREW_PREFIX}/lib/ld.so")
      ENV["HOMEBREW_RPATH_PATHS"] = nil
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("homebrew-helloworld").stage do
      assert_equal "/lib/ld-linux.so.2\n", shell_output("#{bin}/patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}/patchelf --set-rpath /usr/local/lib chello")
      assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath chello")
    end
  end
end
