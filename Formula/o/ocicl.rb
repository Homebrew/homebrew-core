class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "6cc0337bd96f37e91fbac0335e77aa824e603234e862d3fcad7d345ca01b3923"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f705c755476a21cb4aff53957834d1eb5d29fa67501375daba15645d911fc1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e6dd4ec8faf74e5071a64c6ccde055aa01ff21f2741fc327a5bae70481ad489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3feeb064bd5ed8b00d2da0d6560c637787c2bedeb956543b41ef783733469546"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26a6aae215194f687b9384f44383e1c7776befd50850e1f3bbce0c5da0be6ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbb737bc84708fe4fba423fb5a4bb69c1939fd3c41365ca06231585b3c511387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "726742075c5fe25fb4aa3f2d5fe5677ca62258395084fbd1dbf58282557c8c1b"
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
