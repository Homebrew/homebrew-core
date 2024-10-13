class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "c06e0891c9b3d6e58aabeeaac907a100329645a5f73d34797b585046bd3b9c4f"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sequoia: "27c1ae029808d59116becded1c5c3e56ebdc97a59f28efd57990d794ed4eb0d5"
    sha256 arm64_sonoma:  "969a90358f1c49235109791fc1645d33d1ab113abc7db1626adaf12005b2f2a8"
    sha256 arm64_ventura: "7205ddadc8ab378df3f74c0b8f8bd91d21604099b5d271f538241c87aa0016c4"
    sha256 sonoma:        "3ab63218d709395cfaa24be250f14528634899ed22ea3f5c06e6021a18fd1b8b"
    sha256 ventura:       "5f9479b5afde6f52623906571685976be1e516d4a3a456e7e370b4a35e1e231b"
    sha256 x86_64_linux:  "4f159f7d9c71da851b6140934ed0422739aba71ddfa60b65b69808ba3daa1906"
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
           "--eval", "(require 'asdf)", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
               (sb-ext:save-lisp-and-die "#{libexec}/ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin/"ocicl").write <<~EOS
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    EOS
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
