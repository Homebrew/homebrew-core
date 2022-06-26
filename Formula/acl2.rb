class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.4.tar.gz"
  sha256 "b440c0048e2988eeb9f477a37a0443c97037a062c076f86a999433a2c762cd8b"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_monterey: "8ae5843d76f779903854645a53c35b61fe796d8b11caf3fe415a640f815edb6f"
    sha256 arm64_big_sur:  "743c0e77ade1b6d63bbf77e7aa3836d24da387ed3a193cd643a1d3e78469ad46"
    sha256 monterey:       "3d67a21cc7284a17535c55c5768bfc3747f5f052682ded921e8746f2cf5b8964"
    sha256 big_sur:        "d5d341051774fa91ccb5c6c52cefaef85a74f10974c0ab53ef1bf7fc470c3c39"
    sha256 catalina:       "72d322a7b8d02e48d5c67a45383ae1f4f64c6d7b94437ade47ec9a494be1b27f"
    sha256 x86_64_linux:   "b76b5d2e82941d0cba322eb758bf7dd7c3fd233ee57b19c38cef0b4cae51e064"
  end

  depends_on "sbcl"

  def install
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
