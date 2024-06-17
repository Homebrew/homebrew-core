class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 18

  bottle do
    sha256 arm64_sonoma:   "a2b29f19063c7ac4345a6ab1264922918e7a8346ef0df08b330d0ca0f51f1b0c"
    sha256 arm64_ventura:  "f0209490dd1a4176178f5026d5473594e1b0cd34b877fe23370b2c2b077d0f7b"
    sha256 arm64_monterey: "b0d959d12c95c98b8773e6b1710a02bee100fda79d9d2cf6b82b06f906dd229b"
    sha256 sonoma:         "7e17e0a93d948c1c26c1e929a0916947adb107807da564cea24d04025b655efd"
    sha256 ventura:        "143a2117239cae0a18ac7feaf2d4b883f1e28bb8611cf79f900194585fdcc64e"
    sha256 monterey:       "1fb0bf518c9f382122c4baa99bc9b0236f7f85c393e427f15332ea4fe769865e"
    sha256 x86_64_linux:   "09cd24637425ebd96102d7a0d20b6f3b5c5a6dfaa0bc55f3fdc3df4dcef66344"
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
