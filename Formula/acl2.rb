class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 7

  bottle do
    sha256 arm64_ventura:  "f94fa1dc77ddfdd63dfe9d606ca51c1c685b2a4b7b9ce74107c3856793960360"
    sha256 arm64_monterey: "54dd390bab8f979f8d998065c4b068b6fa992e30f4689ffd0e70f9c134ae8770"
    sha256 arm64_big_sur:  "fa3d7764682eb8e1c10fafa7195363395c81beac651b8b6c05ef819e984e5c5a"
    sha256 ventura:        "27040d43e1e0d34aedc90fa5820b6b65ba1eb44fe907977af0feaf2f078538f5"
    sha256 monterey:       "8964e88cae48808a7fdd9cb9b2103eddccadd384a066a3525c9585f8a6088b88"
    sha256 big_sur:        "781b6c3027758962e1ab74b447477ef5406ab5cd0b998f64ac7970f90d6c3202"
    sha256 x86_64_linux:   "e0553008c6f5b908c5b2c201ee21d5d72593d559df10d28fcf2f38f4dd3d2396"
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
