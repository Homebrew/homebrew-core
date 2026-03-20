class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.5.tar.gz"
  sha256 "640082be5b7e4669bdf996ad7203a625076badfb2927ea296cb625fb00807df0"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6879e225c6b1ee5f8b2211304047d67af4ba283dd8fa66b297fc168a67082574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a4b80a43f54fe3971ff7a55a62b130c156348020ca1128e2f1d45b0d4894094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4771506a3042c435b345d3e0aed7747726d476548606323ea774b42771e5624"
    sha256 cellar: :any_skip_relocation, sonoma:        "685c68eb0904b8be78e43463be9ea422edb6415af7d6fd44e38a0f5afba34c9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05d98dd8d694a27c2984be507fdeb0411fdf2a3b06627e7141524ccddba106bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7e0c7967aa3763220eb0e320dbf98eada769262a564d365e4ce04b219453909"
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
