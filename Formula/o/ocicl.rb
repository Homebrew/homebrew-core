class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "5cef99b573152711f1ecae7356db4975178d89960928b1df24e14a49f48768ca"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "295d9a80cd97e8aabf16f6333509f3dc2033c6adca8b2f274438046306ee6fe3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1690669f436d6e51cae2527dba20ce24ff20a1bedc34376fde45a4b2cb198f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "938ca787e3346a890f818800970960fce956abd4e1bd042023bb51564311aa2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a76f459a4b4734dec94d634dc865b4dda7146ec10feaf3b5d5ebed3a83faf0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6455770f0b717c9a35e5dc9b7923d557fcd643213330353ac534dc3e21d6ca92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "932929df5872571696361893f636f412fa21a25002481528c6ce99de1221b92a"
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
