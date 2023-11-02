class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 12

  bottle do
    sha256 arm64_sonoma:   "e15ab30585377d248993a79d7d79c2050e3449636955aab7c0a6fe514c8d7cb3"
    sha256 arm64_ventura:  "67fa855a8aca6c4a97cbf2bf1eb3d21507dbfd5ea9faa7603bd536c228763f31"
    sha256 arm64_monterey: "743c76ba265bed99da2a1a220367fa91b13a5de639283f4a751aea0b168bff4f"
    sha256 sonoma:         "8693c9c5896ab2cce605f3ce6c31d263c00069d93a5855edccf4465ad25f677b"
    sha256 ventura:        "ef772457ab043ac545a233cf013e09e6920cb5c5c9a875bd73dbae23c98e363e"
    sha256 monterey:       "b5af35551cf0f71a154d702a19b179dc1514af31f0d0af1a39bb8a9759b603e5"
    sha256 x86_64_linux:   "c4d9cfc74c30fdc834f6c52cac41aa27b015d7e58bdefc7d2e8df49e0e28dbda"
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
