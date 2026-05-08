class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.13.tar.gz"
  sha256 "067408f0443119a25c2b34a323a829fb953542e367bb039365bdcc0a0b388500"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98ed7566bf7279ba6366f1126737088ebaf8b64f0a1a8c6de2318208131e43de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754988106eb71e96c20a9c82750ea5385d027392c2bdbff41415d706fa87395e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "287359a46ec3a5ef7097d26c2934274e28e67b626b61e0e6a6153460a2da0369"
    sha256 cellar: :any_skip_relocation, sonoma:        "0904ecaa379d8674cb590d276d328be8f4ae8bb7df8fe30d804471e2f48dee3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "150cfd65d47e00af59373a74246762741e3a5de7d3c1d00ec37f6014c60f568d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd1242788626ab152a235d2babdcef635d851b92615b8a1b55bbe37df5c2395"
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
    assert_path_exists testpath/"ocicl.csv"

    version_files = testpath.glob("ocicl/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
