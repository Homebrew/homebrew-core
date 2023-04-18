class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 8

  bottle do
    sha256 arm64_ventura:  "6c8a1761cc768b5ec50b7cc3365e6ea57285cf73227a72ea6bdd5cb7c0c86ce4"
    sha256 arm64_monterey: "ad9d63c303fc113131aff19c980df8c578f03df7396faeae07c91c40966a9392"
    sha256 arm64_big_sur:  "52c805a97d7f24c525f0ea5a4db3a11ac3b7e02be2ec31333e1ffa3c375c33a3"
    sha256 ventura:        "9d5781fc0a32a0d3db848400f8c68a4167cba38d68325e8221cfbdd580385480"
    sha256 monterey:       "03ccab6a8f5acbc14834123233ffa54e7cea07c87c57fa1b692a01042f19e13e"
    sha256 big_sur:        "0da9fba100a9880eee3283d87341c5bd95d2cd6dc175b78f45ff2fe0c6325932"
    sha256 x86_64_linux:   "66e68cbd7d13d7ee59d21842cf8f5a30dbc7faa873931b3431a9fcec696fe10d"
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
