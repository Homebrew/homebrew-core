class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.5.tar.gz"
  sha256 "640082be5b7e4669bdf996ad7203a625076badfb2927ea296cb625fb00807df0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9acd0a3bd0b876c726a2cf2808dbef0b7e51ba14d8ce3acff5131b5cc67daf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e3a2cd7d5c00a956abfc52e9e18c06dc58c6178bd1c5860dbf9b5970da897ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd197e80bbd63dcb3931e5b31856fc438fbd0c43b6872812775406a21f37eef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "903cfe17171bb62419cb3aeaa8ff88bcbed28704d69bfdb0747f728b954248fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0828fb2df62b5c19962aef204863efd7d387a6284c00a7916f12ba9eb946d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44ac94b65559dc0a18bf4b1409d775e340d155df385536e7e022cc06c03af8c1"
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
