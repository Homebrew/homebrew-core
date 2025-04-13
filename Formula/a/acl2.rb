class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/~moore/acl2/"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.6.tar.gz"
  sha256 "c2d73e66422901b3cc2a6f5a9ab50f5f3b1b4060cf9dc9148d076f3a8b957cf9"
  license "BSD-3-Clause"
  revision 6

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "a0f0f0b6755424dab502b14568a4a1e197af0f48f90e0ad67e95b7de70ce8254"
    sha256 arm64_sonoma:  "46d7a4f7d96774541afbe9e7e3552c931972eea85387f65a6db55923f4a0786c"
    sha256 arm64_ventura: "a818308efafc422ff8bb9ee3fa2612062d56e13b6c1ad5db771750ca99b68669"
    sha256 sonoma:        "b4e0848f54372cd7b6fb1f51f3fbb213110cb308825fc1506be5bde7cab9010e"
    sha256 ventura:       "41f117ffdc8e0f43668eb6a3f64030c5863902ef97f5bb4245801c4016dc6b83"
    sha256 x86_64_linux:  "6057ddc56db07ca4c2736d58252f27e46d472271a321336dc7a1647545f4ffb9"
  end

  depends_on "sbcl"

  def install
    # Remove prebuilt binaries
    [
      "books/kestrel/axe/x86/examples/popcount/popcount-macho-64.executable",
      "books/kestrel/axe/x86/examples/factorial/factorial.macho64",
      "books/kestrel/axe/x86/examples/tea/tea.macho64",
    ].each do |f|
      (buildpath/f).unlink
    end

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
