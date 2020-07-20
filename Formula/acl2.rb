class Acl2 < Formula
  desc "The logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.3.tar.gz"
  sha256 "45eedddb36b2eff889f0dba2b96fc7a9b1cf23992fcfdf909bc179f116f2c5ea"
  license "BSD-3-Clause"

  depends_on "sbcl"

  def install
    system "make",
           "-j", ENV.make_jobs,
           "LISP=#{HOMEBREW_PREFIX}/bin/sbcl",
           "ACL2=#{buildpath}/saved_acl2",
           "USE_QUICKLISP=0",
           "all", "basic"
    (buildpath/"acl2").write <<~EOF
      #!/bin/sh
      # See also https://github.com/macports/macports-ports/blob/master/math/acl2/Portfile
      export ACL2_SYSTEM_BOOKS='#{prefix}/books'
      #{HOMEBREW_PREFIX}/bin/sbcl --core '#{prefix}/saved_acl2.core' --userinit /dev/null --eval '(acl2::sbcl-restart)'
    EOF
    system "make",
           "-j", ENV.make_jobs,
           "LISP=#{HOMEBREW_PREFIX}/bin/sbcl",
           "ACL2_PAR=p",
           "ACL2=#{buildpath}/saved_acl2p",
           "USE_QUICKLISP=0",
           "all", "basic"
    (buildpath/"acl2p").write <<~EOF
      #!/bin/sh
      # See also https://github.com/macports/macports-ports/blob/master/math/acl2/Portfile
      export ACL2_SYSTEM_BOOKS=#{prefix}/books
      #{HOMEBREW_PREFIX}/bin/sbcl --core #{prefix}/saved_acl2.core --userinit /dev/null --eval '(acl2::sbcl-restart)'
    EOF
    rm_rf buildpath/"bin"
    bin.install buildpath/"acl2"
    chmod 0755, bin/"acl2"
    bin.install buildpath/"acl2p"
    chmod 0755, bin/"acl2p"
    prefix.install Dir["*"]
  end

  test do
    (testpath/"simple.lisp").write "(+ 2 2)"
    output = shell_output("#{bin}/acl2 < #{testpath}/simple.lisp | grep 'ACL2 !>'")
    assert_equal "ACL2 !>4\nACL2 !>Bye.", output.strip
  end
end
