class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 22

  bottle do
    sha256 arm64_sequoia: "ebe3a281c803a3ced792eb5b190ce74631f20a948671e1c8fb6443675f8c3e9f"
    sha256 arm64_sonoma:  "b87980f784e78c39342098ddac7c9c2df5d8c97ef243fddbeb8c4f10b4ab1e0e"
    sha256 arm64_ventura: "7114531b6baf4ff1dd57232dc8c51f09bd0fc8d790838d1af1c2b68bce007e04"
    sha256 sonoma:        "81bfe6920c37e8ca814e85b4b732e579c447332beb45b567396d58524a554fd9"
    sha256 ventura:       "48a34a86ac01c44768ef14ea1fd553ecc4d3095675a5709c6e17eec04e9cc4d6"
    sha256 x86_64_linux:  "878a82d4763ea2bd5293ca5e5e984fb34c05fb8dde6726f77943a4fad7814cca"
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
