class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 11

  bottle do
    sha256 arm64_sonoma:   "4d9a66e5abfaa62f799541a08d57f1a55e50aaf8d2a2c1d8d85ecd633e4a2b66"
    sha256 arm64_ventura:  "d180d483d96ee516c4553c702326ab23212be5e58b020aa91b1ad8ddd4ac84ff"
    sha256 arm64_monterey: "731f9efc2c1b64567616172fa76bea3ac763b04185f8e957cafb49fd39f14e45"
    sha256 sonoma:         "304ce6c004bba8494a41d34fb529ab565a6fa7f14e2efe8443bbdbfffad0b00b"
    sha256 ventura:        "236b171ce0956e97fda681f1bfd0a5586d4d4018a6477e052f0fe1e7632b2b2d"
    sha256 monterey:       "e52a89ac18a5d7ba3f6eab7180aafddd309040779617122411158a1e3ecd29c5"
    sha256 x86_64_linux:   "51c7f763c558b03fdab9ef1ced74c57d3950af3eb74a5e745ed01202761d5a86"
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
