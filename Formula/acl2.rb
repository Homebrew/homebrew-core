class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 7

  bottle do
    sha256 arm64_ventura:  "a94d2b62422a980725adc902ac5f4f93cb0e934a04ad6a04c5a24000f663f67f"
    sha256 arm64_monterey: "aac8029edb0eab51b7c35114dd7753561122ef67cb7b255811883ea85550e84d"
    sha256 arm64_big_sur:  "0b2db94e5b2fbe940f8bd932d08500e988b61b2fbea2a11c74b99fa7ac0e7304"
    sha256 ventura:        "e4b429ad277178fdb4145380a34580b272edd18f157253f748333ce6bdda9b85"
    sha256 monterey:       "3530dbaadbb2eb3dadf8c9c138822553ef3b587ef7b64a7999a687eae7c1afef"
    sha256 big_sur:        "a91d0e66a6290b209ef81e0d6d9449f75e211f4131d2e307b4a904c16553c103"
    sha256 x86_64_linux:   "4242766e8afa624b28739b2d4cbe874dc3438705c714263242d7532b2284b9fc"
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
