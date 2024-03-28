class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 16

  bottle do
    sha256 arm64_sonoma:   "f23dad57475495b8e888b69a3cf987a30f6c2e4518ad06fe7f052bbdb1e65069"
    sha256 arm64_ventura:  "8c1448f2e268b7d7b60ebb355bd3f66f6a7150c326bf57f6e58e04c0a2201581"
    sha256 arm64_monterey: "d61b0bcf8bc952002c9f0762c13dab86fc7c850744832f9aea8ca71d816f4269"
    sha256 sonoma:         "e7a527822da0c67fc4cee8574efe067e503d4703c8dc8d21f9589609b20fca2b"
    sha256 ventura:        "e62a1f0802a94dc4a8b37282c9e29e702dde9c133efd38c1a7d33d594fd9f8f9"
    sha256 monterey:       "565ed14e6a86484e55def813ad23286d26aad7024bf5112c388d12db60d79d91"
    sha256 x86_64_linux:   "bda5e4ce53c30d7f5275227d88fd08981f692d93acc8539561198851268e4b24"
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
