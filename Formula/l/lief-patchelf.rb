class LiefPatchelf < Formula
  desc "Robust, modern reimplementation of patchelf based on the LIEF"
  homepage "https://lief.re/doc/latest/tools/lief-patchelf/index.html"
  url "https://github.com/lief-project/LIEF/archive/refs/tags/1.0.0.tar.gz"
  sha256 "2cf412695ff739d82e129db441e5c2025f3bb4873a3d3a1d3dd4cf300b682abd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c446577429a5b41c4a2fb30b020f9eabb7848d7fea57ea892bf28222d382a19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f11bf7800076f20d0bb8dffa03bb32d6180110e78fed4c8ae774f29bc5969798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e28674cec6e385de97749827fea10df1edbc5bf2a84f3b9792107f504f98dc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3490686cdbd530e000ba271ddc728e6cbe6b92813ed6ad5527489c46e9ed053"
    sha256 cellar: :any,                 arm64_linux:   "f4706455821d3f2dc5f1d3e08ee277130dbdd11d43c137f694e531f7a119427c"
    sha256 cellar: :any,                 x86_64_linux:  "94f05b8b784a754774f9ad8df87c6bda5272840eedae921c9b985671e9c4686a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "tools/lief-patchelf")
    system bin/"lief-patchelf", "--generate-manpage", man1.mkpath/"lief-patchelf.1"
    generate_completions_from_executable(bin/"lief-patchelf", "--generate", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    cp test_fixtures("elf/hello"), testpath
    assert_equal "/lib64/ld-linux-x86-64.so.2\n", shell_output("#{bin}/lief-patchelf --print-interpreter hello")
    assert_equal "libc.so.6\n", shell_output("#{bin}/lief-patchelf --print-needed hello")
    assert_empty shell_output("#{bin}/lief-patchelf --print-rpath hello")
    assert_empty shell_output("#{bin}/lief-patchelf --set-rpath /usr/local/lib hello")
    assert_equal "/usr/local/lib\n", shell_output("#{bin}/lief-patchelf --print-rpath hello")
  end
end
