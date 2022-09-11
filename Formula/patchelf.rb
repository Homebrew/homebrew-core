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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada8f7b9a01aa3a55459c8fb6553efedbfbfa6eae32ce43ff7eac949d374addd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64970a9f18153245996305d83730053b4fccf973be7a9e9f0b0da4c620487673"
    sha256 cellar: :any_skip_relocation, monterey:       "da636e1ad15c9018334add7a509b34f557536942f0706a0cc688f9d480f0a4b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6c8d569d7e74d30189cfaea5c39207ed6ed9a04f41ed1818dc8a841cdc6bd92"
    sha256 cellar: :any_skip_relocation, catalina:       "9382f4722ce6925a2af6376daafb665ab8ad3e0b6e1881752e4da0e070f4ad69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37ebeb67ddc023af88a2e3e7ef9d84c49f40abace008d660f5ab0d6a203e91e8"
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
