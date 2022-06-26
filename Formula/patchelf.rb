class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.14.5/patchelf-0.14.5.tar.bz2"
  sha256 "b9a46f2989322eb89fa4f6237e20836c57b455aa43a32545ea093b431d982f5c"
  license "GPL-3.0-or-later"
  head "https://github.com/NixOS/patchelf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93f86615872480fa711de7c7abb8874b102a0ec71a6c7b526f24de390e768c64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c44eb9355929d5d5a29eef98ba237bb0be07e887dd1a78d597f9193eb4c6a86f"
    sha256 cellar: :any_skip_relocation, monterey:       "56aa96ca13ab94c578f37dbd6f27a66df3f8a7ff065c69e24fe96945570dc5ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "4066a672a259b9f5e63c8733848436c7b327a7855cdf9befd0634f437314971b"
    sha256 cellar: :any_skip_relocation, catalina:       "c1c28ffdfd4dc20b6fbea1db1f1d26c1456968a041bf99e84bf9973719164884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78bf9f5d693ab680158e2bdf341c4915712078fee53421c05f5a87af7f2d9cc"
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
