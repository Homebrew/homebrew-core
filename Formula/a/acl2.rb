class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 20

  bottle do
    sha256 arm64_sonoma:   "950990850f517b2f23a0a536ae3f2a81dd8600fb702ad12b5444932b9baa89c0"
    sha256 arm64_ventura:  "8c8c4dee9bc5b041159aafa2ee29ebc7433f5862bef46589a3fe98365ed26e4f"
    sha256 arm64_monterey: "ab838adc58c06712cf735b2553f37431e7fa998bfa3fd2ded884184e13e18d34"
    sha256 sonoma:         "c56551d509e45fcccb4a0eba75802732dd80fb2c9f1996ccb92aa5234e0e8a69"
    sha256 ventura:        "f78efb615ca9592a851fc3fd3edce07334041d64d330f10d0ae01c8297b39549"
    sha256 monterey:       "00b5a314bcc064d46e21974d4dee9b912672c58a10c435e4eeced070a07879f8"
    sha256 x86_64_linux:   "35ec849b92aee5cd2202ad94f2855d9bbd9e5df983e3656d98898299b322d43f"
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
