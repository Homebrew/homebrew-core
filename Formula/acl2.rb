class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 10

  bottle do
    sha256 arm64_ventura:  "17e3a8dd8c2c19f92cd7dc7e2baca906a2548ebebcba8c70ae91a2b021dbd1fa"
    sha256 arm64_monterey: "6e39a6186b87bcd502e2323d84825a5f10e0c8b123c05f061e709ca0abbdb329"
    sha256 arm64_big_sur:  "16c7420de934b513830118c441c5fb1155588f3d4873d36c2efdf3a363d4557b"
    sha256 ventura:        "dcd91d85c04c5a27ac02c3e2f72a75a9b9ff51095a19776d720b2078eb01c362"
    sha256 monterey:       "af360de53367c7c21a370489cf3bf33c1c80a0bd2983aa80e4b74eeca848e2a6"
    sha256 big_sur:        "f48f7f64110eeafaa0c799b6889897c9426bf0383d83654f0e18f5bcd85b643a"
    sha256 x86_64_linux:   "3e4310f222f6708b7cda170adaa90d4940ea272f3929f555d84a84664be3a33b"
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
