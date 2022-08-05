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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1b16e8d04523d1fa94f1d19898a985fc9ab9e0420445c87f164dbf9023804e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c2b7f9471b27bb49f6b1697271f7f31241da75734dddd17e52fadcc4934f25a"
    sha256 cellar: :any_skip_relocation, monterey:       "44115b65b1cb820a63108493f1491ea037466d8d551b50811a4c739572d21603"
    sha256 cellar: :any_skip_relocation, big_sur:        "14489c17fa69fe7d76415d1ca42c4d1322070e326d1f594636ce08a8a787f1b0"
    sha256 cellar: :any_skip_relocation, catalina:       "927296d5ec2ed47736f021e97c9b1a51414534d4a573cea9be7a831bc773538e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dda0f894d7143569e5aabbba721792edc571daea6ed65f73be94a151d5ab48c2"
  end

  on_linux do
    depends_on "gcc"
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
