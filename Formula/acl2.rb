class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/8.4.tar.gz"
  sha256 "b440c0048e2988eeb9f477a37a0443c97037a062c076f86a999433a2c762cd8b"
  license "BSD-3-Clause"

  bottle do
    sha256 big_sur:      "5df4406ac7d74ece58c60f8bf83e8fde1139fe1b0da8d9a83e77a8b2aad404af"
    sha256 catalina:     "bfe8d73561e904ba9fd0e3f44c3b7c77decca4346e9428ebebf4f9b3fd553741"
    sha256 mojave:       "a7934877c55e93a626e48473adf408606c423e427bbcf6c826a69394e8634195"
    sha256 x86_64_linux: "74f3c4b7970761a3ab6e5c513b0d3d6df83c24e534de3634fb032c3b4810b2fc"
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
