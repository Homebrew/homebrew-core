class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 6

  bottle do
    sha256 arm64_ventura:  "b525d5915208dd22593f96c9c5303f69e0083a3e2ea5c9c0edae6fc437031dd7"
    sha256 arm64_monterey: "c520f7d86c642acd016d769c0bde9b582a6c43b073159e3819556a392517e838"
    sha256 arm64_big_sur:  "7434c1f76be05e8c43aebd47fd9f0e5899e5106cedcdfb0d4017eae0fdb0db69"
    sha256 ventura:        "2246bb2c819dbf83c840f060e5e3e5aa511abe0056cfce61d70b86b05d260a0c"
    sha256 monterey:       "7b741f69ae481feb47341c927435235d9868dc1f18a8cf26282d235291fd0f2d"
    sha256 big_sur:        "3c2547ad869166c3310848a6187602eea558eabe981b04669b4dde43836765fc"
    sha256 x86_64_linux:   "434c2bc5bc559cc92031d822445c249759d9b60976fb17ea3c32debe8ea20d55"
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
