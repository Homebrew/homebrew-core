class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 arm64_ventura:  "0f652ce111d1bb686ffe89f7ea9508f9a2a1062b474fdec0a5e439074bc59384"
    sha256 arm64_monterey: "19b51e20d410fc5e6415dfbd73483ed806a255af7e34d78612f3ad8bb69be280"
    sha256 arm64_big_sur:  "9f020966f12897734c3f7bd452b22a76bd8eb6e51cfd2aab581095678d2ddb46"
    sha256 monterey:       "4ffb9a9f634f984e2c972f5ffe232400c88771ceb860db36185a9eb28b196eef"
    sha256 big_sur:        "cbddcfb9aae7f7e7f878e1955c717fe76cf2d8debfa29d35bd29dedaf5e50d9c"
    sha256 catalina:       "1fc7486ce812f73501191904e282e79e459290a88b8d9dd5d5443c385f69bc17"
    sha256 x86_64_linux:   "b317e27e1af5f5c60cff37735db89ffc2c3d9ae7f45aa5e45a3da1fd678c06af"
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
