class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.19.tar.gz"
  sha256 "2ca7fa13409f5bc7a73eb49bf048948fe29bc6c083eff5f8d55a49a15cd5f470"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "2556134d14ba8f50b0aa2db339819bbd0ecff4afe7555283640bd9a4e7948db6"
    sha256 arm64_sonoma:  "6968a5dfefeec07e9ba18cded688537f089703a54ec41c26f38ca2587a57587d"
    sha256 arm64_ventura: "878f16b4c91daafd1857c3525c1c21302f33db751b331896363927142c922374"
    sha256 sonoma:        "da25f07920c955bd2f9de073a10e721924b6ad0a36155420903a9796feeb4d16"
    sha256 ventura:       "c33f8c47744e9824b20ae0c45dc5f1dc2196e241839297ccefaadf4514464ea0"
    sha256 x86_64_linux:  "7ce2aa2e3591ee66c389eb58997357e082cc33a213ddae90d912a55bb17a7a8d"
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
