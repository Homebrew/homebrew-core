class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia: "66b22cb0d45f3d257f262609449355a40c42961fb4bdcd0363b1d71b4e6120b4"
    sha256 arm64_sonoma:  "00fe86f8d1ec5da39241f0b33556d48a073a1db14b43aeda72161a3cb78db66a"
    sha256 arm64_ventura: "bdabf69074d1c7b7a4e38855a46138a244c4399e8b9d682b3630dfcf3c394083"
    sha256 sonoma:        "416c5106bf2cb75529b16ac53a12b64d08958b5c811cd2c6f70730e6e8e63f30"
    sha256 ventura:       "f8aa80638f6c6543a5f4c0f51243441cc5f0b085043ba0f9abe199b112464866"
    sha256 x86_64_linux:  "9506ef99917e5fbe44656053c911af98184f988c9584b8c8c712466a7d609993"
  end

  depends_on "sbcl"

  def install
    # Remove prebuilt binaries
    [
      "books/kestrel/axe/x86/examples/popcount/popcount-macho-64.executable",
      "books/kestrel/axe/x86/examples/factorial/factorial.macho64",
      "books/kestrel/axe/x86/examples/tea/tea.macho64",
    ].each do |f|
      (buildpath/f).unlink
    end

    system "make",
           "LISP=#{HOMEBREW_PREFIX}/bin/sbcl",
           "ACL2=#{buildpath}/saved_acl2",
           "USE_QUICKLISP=0",
           "all", "basic"
    system "make",
           "LISP=#{HOMEBREW_PREFIX}/bin/sbcl",
           "ACL2_PAR=p",
           "ACL2=#{buildpath}/saved_acl2p",
           "USE_QUICKLISP=0",
           "all", "basic"
    libexec.install Dir["*"]

    (bin/"acl2").write <<~EOF
      #!/bin/sh
      export ACL2_SYSTEM_BOOKS='#{libexec}/books'
      #{Formula["sbcl"].opt_bin}/sbcl --core '#{libexec}/saved_acl2.core' --userinit /dev/null --eval '(acl2::sbcl-restart)'
    EOF
    (bin/"acl2p").write <<~EOF
      #!/bin/sh
      export ACL2_SYSTEM_BOOKS='#{libexec}/books'
      #{Formula["sbcl"].opt_bin}/sbcl --core '#{libexec}/saved_acl2p.core' --userinit /dev/null --eval '(acl2::sbcl-restart)'
    EOF
  end

  test do
    (testpath/"simple.lisp").write "(+ 2 2)"
    output = shell_output("#{bin}/acl2 < #{testpath}/simple.lisp | grep 'ACL2 !>'")
    assert_equal "ACL2 !>4\nACL2 !>Bye.", output.strip
  end
end
