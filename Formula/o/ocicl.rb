class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.22.tar.gz"
  sha256 "78e378a84f96f52a0dd8518a9d049f94d2d76ee0c3ec7db1384104e45b5c20e5"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c34b753fac4edbd33b038d6ddf96cdcb6d2805818b9f4ea88630e2587682f1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "588cb750c2337b57daa5f554d579c66a6b461159056b7cb599cbb96b1ce733b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "273cc467c930cd4aad386cdd73074b0e4458899665d21340ad36187661465c17"
    sha256 cellar: :any_skip_relocation, sonoma:        "c053d1994fa359e3b98e771eca7b3daa50cec28cc96e0a724a9533e1c0b08313"
    sha256 cellar: :any_skip_relocation, ventura:       "f5985e0d9e81cc99ac8a826fc53d3483116666c71ca67e2e9eae0bfc1628c7b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99d3aa5b3200fe1a2115554d1ae13f5351b6ff59c082d2b9854d2e2a48200364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e4a516d90ad60992b99ee680c4a6585a9dfe20f1daf2abb4bb14fb32fd85c6"
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
