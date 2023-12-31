class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 14

  bottle do
    sha256 arm64_sonoma:   "fb246d4bd12bfe4a6357b95287496a04b5e82a14a11def995769fcb6fc1e5d84"
    sha256 arm64_ventura:  "3fc45c231df4a0306ca4acac70d1b5eca9685a0eca765e2bf2c00a0d641fcad9"
    sha256 arm64_monterey: "bcc33b0a2ab4c0027852f015f1fa314a72039c7b6c011bde01b8a27ef748ec56"
    sha256 sonoma:         "8a02b5e49ec10608b2d2b1f313694dd3e188a6e310674f3b8280532c612279fb"
    sha256 ventura:        "c868fb6922a7b8f8bf9dcb6b472a170542b6416a3d011306df830a6f8d96a36c"
    sha256 monterey:       "8e50a93f9d6f7b4ef819646cc00ca164a618caad79b3a5028c41d641b8f1c306"
    sha256 x86_64_linux:   "db84ce293fb160bf824b53a79ff13f51813c0ea4bb3446644b3f57527f360515"
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
