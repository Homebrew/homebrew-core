class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.7.6.tar.gz"
  sha256 "d9a6a90046e53a524036014fad0c421dc000c69896e05eba0edd061920da38bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e1a0c42f4b7a29176af4bbfed2066bb6988a4d58876ad6cdea344b34db3f237"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dd1b20727264752701b9923ed11196880dc562aa31f4d6ed8bd1b9f67973b5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76b3365a2626cc0f9457e269f4a0b20d6c2e308e7c3c4f6c6b9da34c6cf53205"
    sha256 cellar: :any_skip_relocation, sonoma:        "b17bb0b5ebea318a1f26f9918b05367e29aa5ebd2fe78f90ef6fad30c1f25122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1aac2ff4d312ad75630ad99e0d3f064cff7f99a83db1f1224fbb0816a54ac28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31bbabecf8a134c7a0598ed4f3fb8d8ed57ef9afff45b6fed2142fe741e2a25d"
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
