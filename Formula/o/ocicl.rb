class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.20.tar.gz"
  sha256 "a5e87e5880bb5415e9a4cdff4fd4334fc2a19a497c7aca469f359f57675eb913"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sequoia: "a288df194bab1fe4374666bbd75996d83703cef0a23813cc08e96885ff13da7f"
    sha256 arm64_sonoma:  "4fc8a27fb2b92ee492917f129c18e45a33649f53bea6ef59e170a89958fb560e"
    sha256 arm64_ventura: "23ed104685907d189b6c0813c8693ca13935915954294c4107f736018e6577b5"
    sha256 sonoma:        "9d76d78c741d5cc61ece97fe995c72ca94211e54a6022e581109a229fe4e8d57"
    sha256 ventura:       "3e555e8e3fc008f0897daf30b57aaba9850543da449a635d471076faa6303fe3"
    sha256 x86_64_linux:  "2838f271bc1dc2c93ec8eb96bc24a8ad4e7d85df77345c2f61222b1119e7ec64"
  end

  depends_on "sbcl"
  depends_on "zstd"

  def install
    mkdir_p [libexec, bin]

    # ocicl's setup.lisp generates an executable that is the binding
    # of the sbcl executable to the ocicl image core.  Unfortunately,
    # on Linux, homebrew somehow manipulates the resulting ELF file in
    # such a way that the sbcl part of the binary can't find the image
    # cores.  For this reason, we are generating our own image core as
    # a separate file and loading it at runtime.
    system "sbcl", "--dynamic-space-size", "3072", "--no-userinit",
           "--eval", "(load \"runtime/asdf.lisp\")", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
               (asdf:clear-source-registry)
               (sb-ext:save-lisp-and-die "#{libexec}/ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin/"ocicl").write <<~LISP
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    LISP
  end

  test do
    system bin/"ocicl", "install", "chat"
    assert_predicate testpath/"systems.csv", :exist?

    version_files = testpath.glob("systems/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
