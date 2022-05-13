class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.4.tar.gz"
  sha256 "b440c0048e2988eeb9f477a37a0443c97037a062c076f86a999433a2c762cd8b"
  license "BSD-3-Clause"

  bottle do
    sha256 monterey:     "825d7272eb277b9756f6816cb89d0c6dec9b2719158d3f8ba2d6a50d0b2d7f9d"
    sha256 big_sur:      "4d5eeb80445ecf76726e5e156eb3acbd57cb176c801883f4ba75b25cecc2d258"
    sha256 catalina:     "f3d0b44ddb425ca52de5ee98d31b7aedfb9bc0a3ce3d834f8b1a39145e7b19d3"
    sha256 x86_64_linux: "17008cee54fd6d67e75bf36bf98ce4ca8618f428bb0a7b817ed1d49555fa6ac1"
  end

  # Homebrew ARM CI runners hang when trying to build `acl2`.
  # See https://github.com/Homebrew/homebrew-core/pull/96455
  depends_on arch: :x86_64
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
