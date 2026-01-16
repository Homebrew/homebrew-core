class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 13

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "79f4d9fcd79ff956c2b698d4a0d1400506a9c83a032b3b675f67382c2e2ad805"
    sha256 arm64_sequoia: "dcb4361aebe67010a2b772fa08b00d05dce7f44e342101da07ce04fe3b4d41ed"
    sha256 arm64_sonoma:  "238c9edf710d6c268f15b57b0da402f900618c562df34d359e5727e95a03d4c6"
    sha256 sonoma:        "465e7552071a28adb773e85803c29193614d27fa020783e0a758d4fc1b7a1a99"
    sha256 x86_64_linux:  "0ae5f2bf2d53143d05ad171874894656618f1b10b23a2d7c5e43a461351aa6b9"
  end

  depends_on "sbcl"

  def install
    # Remove prebuilt binaries
    rm([
      "books/kestrel/axe/x86/examples/popcount/popcount-macho-64.executable",
      "books/kestrel/axe/x86/examples/factorial/factorial.macho64",
      "books/kestrel/axe/x86/examples/tea/tea.macho64",
    ])

    # Move files and then build to avoid saving build directory in files
    libexec.install Dir["*"]

    sbcl = Formula["sbcl"].opt_bin/"sbcl"
    system "make", "-C", libexec, "all", "basic", "LISP=#{sbcl}", "USE_QUICKLISP=0"
    system "make", "-C", libexec, "all", "basic", "LISP=#{sbcl}", "USE_QUICKLISP=0", "ACL2_PAR=p"

    ["acl2", "acl2p"].each do |acl2|
      inreplace libexec/"saved_#{acl2}", Formula["sbcl"].prefix.realpath, Formula["sbcl"].opt_prefix
      (bin/acl2).write_env_script libexec/"saved_#{acl2}", ACL2_SYSTEM_BOOKS: "#{libexec}/books"
    end
  end

  test do
    (testpath/"simple.lisp").write "(+ 2 2)"
    output = shell_output("#{bin}/acl2 < #{testpath}/simple.lisp | grep 'ACL2 !>'")
    assert_equal "ACL2 !>4\nACL2 !>Bye.", output.strip
  end
end
