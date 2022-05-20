class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.4.tar.gz"
  sha256 "b440c0048e2988eeb9f477a37a0443c97037a062c076f86a999433a2c762cd8b"
  license "BSD-3-Clause"

  bottle do
    sha256 monterey:     "981ffcee53f9b27768d25c675ff7054d6167e472b25464b8b863814757358c05"
    sha256 big_sur:      "bfdc87ec318de4ad791b7f36a0c8e5c60c49184a2f7da5bcb8a86506f3c40a10"
    sha256 catalina:     "5047132db95e89392bd15b7b8c0f7ff2374742f5b0a587e2489b2dd37a048f9d"
    sha256 x86_64_linux: "72514be4dcc48b2cebc9671056a66f7006c584ff62120988cd6febe765f44b3e"
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
