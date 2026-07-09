class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "6cc0337bd96f37e91fbac0335e77aa824e603234e862d3fcad7d345ca01b3923"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec74dc9ad0ea1b954e50a84fcf350399aa2a16ff978619a69be55bac52b36b82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b79bf7c0504f89240aa6ca8d871c9aed09a209f0bd0f6755bde418a72a3087af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4f48794453dec07e957d442b5b4635510c5f7e064fcf0d59bd7094d4bd925b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "723250a16f978c5d59e24cf1d1496fcb0607cf9133f8ea4f120a053b02c8d510"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afbe6ce5dcab2ea674dc658bee948e5a6a46fa06355c85e6252883edb1ccf4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe8af2a9154aa913430d525a908fc085728a670ddc88bcb79a68e08e2d5f25a6"
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
