class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 12

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "94355fb2567b351ac7e5832f26870195d6f95608ff4c9f5f749259b2d0c9afed"
    sha256 arm64_sequoia: "19095298b8b2df47141d7d2a7c8d787647c43ddd826e5d9e4b77ebe3057825fc"
    sha256 arm64_sonoma:  "a9ee35907c404d5213ffcce6fc25ad15529b6bef707a14cbe62a8f2c03023dfb"
    sha256 sonoma:        "96441e127c40f8df05490bd096099904fe63acaca156ef7b4da4efcef38595c9"
    sha256 x86_64_linux:  "bde3797c8e3d64ab6025602b9591e56d1d84dc0d5ac1deeddf2c35ce0945d153"
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
