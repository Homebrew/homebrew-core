class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 5

  bottle do
    sha256 arm64_ventura:  "9a20ffff1c34e7390c77fd9027b3d629b285203fae80bda7990912f70fdc49fa"
    sha256 arm64_monterey: "d2b4968172ce96301f6ed766eb751ee0151121c456eab0867521e7db12a79ca9"
    sha256 arm64_big_sur:  "1ce6fd880cdefa123ba6310d2b48bdc48635fdc928b3d5f0718ef16317132a7e"
    sha256 ventura:        "84603075ad8f6c8ec77a5537ddee2addcfcf494b609311f1d2ab0d48a3ba868b"
    sha256 monterey:       "264e84666fd09704371b19a99a0920cf2143de55a14ec9a9d5595c2df5a39190"
    sha256 big_sur:        "54be57b40b5516d3e9a2d1a22131ab6a59f8dd9a0963dbf073fd637e51b24f20"
    sha256 catalina:       "1b6b47f7379ae6cc89abec107a51647493466fb6cbf2b170eeae0bf957e42484"
    sha256 x86_64_linux:   "b1a9f012453133df7f80628d974bc36503873534fc3266dc7710fa1f6832a8d4"
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
