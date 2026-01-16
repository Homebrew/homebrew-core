class Libdatrie < Formula
  desc "Double-Array Trie Library"
  homepage "https://github.com/tlwg/libdatrie"
  url "https://github.com/tlwg/libdatrie/releases/download/v0.2.14/libdatrie-0.2.14.tar.xz"
  sha256 "f04095010518635b51c2313efa4f290b7db828d6273e39b2b8858f859dfe81d5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77f8ac3d31bc58f8e000a6b065fa1eeff3c0f832e1d4e3c5fa67b464307c4e87"
    sha256 cellar: :any,                 arm64_sequoia: "59dcf66f922dd1edaa379fb0ef30034585a7a1760ad0887c95afc0ff00ea667c"
    sha256 cellar: :any,                 arm64_sonoma:  "b8b5fb03ad235122f83f7154cd9cfc473748cc6fe49c0d940fe280aa44a8ae12"
    sha256 cellar: :any,                 sonoma:        "d534412d18b23018afb960d969edcfd5f09d51ccf7107b99aff0091503ebc579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1aa88b7f1e58078eb57f8cac2920603e61e79f52c9679805a1bf4afee238e2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2296c37b6f7f5499b944e6e0d553e3ceac5a3666046ed133d495748045a4835f"
  end

  depends_on "pkgconf" => :build

  def install
    system "./configure", "--enable-shared", *std_configure_args
    system "make"
    system "make", "install-exec"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trietool --version", 1)
    assert_match "Cannot open alphabet map file ./list.abm", shell_output("#{bin}/trietool list 2>&1", 1)

    (testpath/"test.abm").write <<~EOF
      [0x0061,0x007a]
    EOF
    (testpath/"test.txt").write <<~TEXT
      foo\t1
      bar\t1
    TEXT
    system "#{bin}/trietool", "test", "add-list", "test.txt"

    (testpath/"test.c").write <<~C
      #include <datrie/trie.h>
      #include <stdio.h>
      int main() {
        Trie *trie = trie_new_from_file("test.tri");
        if (trie == NULL) {
          return 1;
        }
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldatrie", "-o", "test"
    system "./test"
  end
end
