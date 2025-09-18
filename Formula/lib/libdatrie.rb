class Libdatrie < Formula
  desc "Double-Array Trie Library"
  homepage "https://github.com/tlwg/libdatrie"
  url "https://github.com/tlwg/libdatrie/releases/download/v0.2.13/libdatrie-0.2.13.tar.xz"
  sha256 "12231bb2be2581a7f0fb9904092d24b0ed2a271a16835071ed97bed65267f4be"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95efc78786bed41afeb85e4481b7e418982b2a1c9ba2eca5f058b779dd204687"
    sha256 cellar: :any,                 arm64_sequoia: "f864dccadb35cd53fcee3e84a369d0b7ca10c842b8771a1c465d44fb03b71a84"
    sha256 cellar: :any,                 arm64_sonoma:  "66daae07645d7b488dfdd19120830ea7226934de6434370f3a174d6b49a6c16c"
    sha256 cellar: :any,                 arm64_ventura: "541b03e5526b7ff6814697f7d343827d120cbeb42e83b441e4264b5f72bc8f1a"
    sha256 cellar: :any,                 sonoma:        "cae5e0af929b08ab076d3669675a659a974ae1a860d6a57cce0f75728c22037d"
    sha256 cellar: :any,                 ventura:       "83b886b9fc24c2f45cd98584c91ab3eeb14c3838c456026216886d9151811f93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a04b4f1c659bb58c95db895643c02d3b197439c3ae2b0530bde75ea898a7d4b"
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
