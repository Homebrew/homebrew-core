class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "2b3749b91c6b2db37c38431f1d3fc1d9804beca88c50e8bba35f358e8a529c65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "991f2d8c21c7809d669cae81bb881b2907f87df6ed6e9b8b5ee9e66847f98116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22c1b697f2f983f5fd3e8069a1dd0be6d4ea0762e009c121c1074f1f97de5200"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "682129a01330de2132414b483d62905dae5dc46e8e1a835461e800b29aa45c08"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0d22421ad17f279f35903ec748c7cbe2cf68b5cf4ada9fbbd16ab2cf865ba8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdf5dec040d311954b604a1a71fd384387f72222fd6fe79f6f88b9c0382dfcd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fb745b5e4ba9bb2659968c81c2b3c8abdfeae995e52aae297eb4435818517fd"
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
