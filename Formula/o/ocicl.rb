class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "4a727d50c0e09775d7e936c28ed609bf08ca4a83312f87d7e1e38e25232aa616"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f1078dfab780ff7a74ecb432340cb7b17a0f6c68394d5f3c57555e7f1206f69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "159de06103926734dbaabf59cd399bf4da0c4a4c611bb0770d7b70ea86dd36b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "411b0baa09421bfa68ba3105b9cf0212736154816f1c25e21a0a54d963cb993d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4415157ca89d89fd16f1fc40b8290c9e829978f55ac5629c354be6d6cf9e270"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fcd836bf0e0d7277938f2798351c673c8bcde2cf6e85dd2dd6da49b79bbeed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c09a8fb6c2c947bb71b8f90e04ebd1c85df086314f436ac88a3ce875d866f4cf"
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
