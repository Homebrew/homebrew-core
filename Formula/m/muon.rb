class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.3.1.tar.gz"
  sha256 "14b175b29c4390a69c1d9b5758b4689f0456c749822476af67511f007be2e503"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a4100679212be30e2177fa7dfde83b4de7c4d6132910325a83700560c205062"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5b98c4004f09fef13532ee958bbcd06f90e9394a90efffff3b4507c794e2c93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c9e647228c6ce31f0157f2d13a9bf241519d2c05c1c206edfd401b2b2ac1415"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc3fb8dc981789a92fc2006950159fc6e21c0ff9d78a5718048e15808c7b800c"
    sha256 cellar: :any_skip_relocation, ventura:       "6d11e6856f94e6d16b9208378613e155dadaaa062355347c6fb107e24c49f35f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df1c8f87d4401ac11a86c00d8e17f8088c12a6654bbc31fea1ac15fd76e50d0f"
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
