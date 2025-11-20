class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.8.4.tar.gz"
  sha256 "06084148357900445227677014b0b0a3ca2ab08f360b7cfe180a183c903199be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccfc5e642ccbf20d3705f30fc8c08b49c189fcea87bcda0baab32a7681cabe07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed839616189acd684e5b2c20e98bb142b34b88f0a8d51f24538302d32f677eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88b58dc452e097fc683178939c8bbfd2bc10db0d6c71b3a82d27c57d2dd3bf1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "95eb7b099bcc1f586a149b4276e79d2b53fdfe5ddaad417e61a15b3f653603d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4b0cea622fe4f70f303e2027cae466db71a9761a55be120e1154e33e1a0ce5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cbefe855c85daf9ba1213239e9d901b1c997e7c9d26f07fc6a800a5b3b06a88"
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
