class Acl2 < Formula
  desc "Logic and programming language in which you can model computer systems"
  homepage "https://www.cs.utexas.edu/users/moore/acl2/index.html"
  url "https://github.com/acl2/acl2/archive/refs/tags/8.5.tar.gz"
  sha256 "dcc18ab0220027b90f30cd9e5a67d8f603ff0e5b26528f3aab75dc8d3d4ebc0f"
  license "BSD-3-Clause"
  revision 17

  bottle do
    sha256 arm64_sonoma:   "44b0a40884316999b8a86ccb10f8a5305e7aae0e43be4da2ae3f6f15a281faa9"
    sha256 arm64_ventura:  "779a635b21cc9e5c105b513537744f921dd3304e745d310ecafea8c649dba824"
    sha256 arm64_monterey: "0139012fcc7559006ca74fbe3aea86766a207086b5f1068bf2fa6af7d98a4a9f"
    sha256 sonoma:         "2542d963486a6f14f36eb0408b8cbf21a4343482b8a46941637ca91d9231c1bd"
    sha256 ventura:        "482811237e80a3dea302f4252796aa47e66b5b98076471d3abc4e9a735284772"
    sha256 monterey:       "5756c1efc9b640cb9b4678375aafa81068dedff6f07c4371c04fe27aff1ebd86"
    sha256 x86_64_linux:   "844b304093f8574138969b79b7f2341cd1f3da160fdce1db85305a56aec7e9c5"
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
