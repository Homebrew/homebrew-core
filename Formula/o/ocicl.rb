class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "6cc0337bd96f37e91fbac0335e77aa824e603234e862d3fcad7d345ca01b3923"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8f369f35972c548718c18fd9342a3bb9bdeb0164556828927611b0c548d2058"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d57622b49ca6c5783411b06813c26b52644872dd41e9a59f94bbe11e3c4ed173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "480eaa57db079e02f470dde75d678cda1fc273923b13d4c0b72dff0b358146d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4970b8cbf4f33b53dc60e6a567fd3d5b9dab0c83de0c00eb0b1ec0d6c2694c1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6c066cd24c9cf834c5b1dafeb16ce54b3c5347879fdf15e369dd6423f7c1ec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7834fe9677802457f4fab77703d0244ecb92c9ee487975fb6e76dfb46221796"
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
