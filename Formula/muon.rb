class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.1.0.tar.gz"
  sha256 "9d3825c2d562f8f8ad96d1f02167e89c4e84973decf205d127efd9293d7da35b"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "599a1f5f0217e01cf7b667c2494ef54b044739e73f53857b59c35d1de556aae7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad8cf39e3e63840da4b231b72fbd110c130db3198915a990ae69b17fa4d378df"
    sha256 cellar: :any_skip_relocation, monterey:       "ccf9c47e6284d493903c6ae333f23a97c70d2b86ff16592689b462b23ea5340f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce6ae0711e205e8589e859733d0c4b37f06fe2a1a6ca88cb3c71ea6db8e1da94"
    sha256 cellar: :any_skip_relocation, catalina:       "6fb0db84edab9d3c80d565ada5a547476864017d84758c9c9fd93c13b954cd78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec136025007be06fa02683da62a48c49bbb4149c428392a917699f1cec58418b"
  end

  depends_on "ninja"
  depends_on "pkg-config"

  def install
    system "./bootstrap.sh", "build"
    system "./build/muon", "setup", "-Dprefix=#{prefix}", "build"
    system "ninja", "-C", "build"
    system "./build/muon", "-C", "build", "install"
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    system bin/"muon", "setup", "build"
    assert_predicate testpath/"build/build.ninja", :exist?

    system "ninja", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("build/hello").chomp
  end
end
