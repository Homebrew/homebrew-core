class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 10

  bottle do
    sha256 arm64_ventura:  "8752b12e385983197037b2c2d9afaacaad6f9bc8f2282d1bf5f1e7efb28003a2"
    sha256 arm64_monterey: "1ed29ac65859c1b9d116ec370430a7fe2c7cbaf42fdc43f4e1f47c308daa124f"
    sha256 arm64_big_sur:  "387282792f41c7d89ab357b21249966a6e3758818796a51e7c98286a811fd1a6"
    sha256 ventura:        "1ad7ba9a8e738da3a8e12369bc7aa5b9e4627d950c3c3350d9627df38c0c1b31"
    sha256 monterey:       "9fb0df96fd48546ad1bbcb52e0320ce343f6b06dc8e45bd5ac957ecc30b133a7"
    sha256 big_sur:        "346faa83e90acb38abf3e6a0e3260faa4d0b2a9c98cb6fdd7c46c3b9c883698b"
    sha256 x86_64_linux:   "1511c4c21a77a36870a0ee67ffbaef4bab1d6a49acb65db8ab62771efe7c9dca"
  end

  depends_on "sbcl"

  def install
    # Remove prebuilt-binary.
    (buildpath/"books/kestrel/axe/x86/examples/popcount/popcount-macho-64.executable").unlink

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
