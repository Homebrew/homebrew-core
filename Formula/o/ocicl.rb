class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "3477659863514ac1188b7177ad9b75a93b580a42c67573cadb4bcb67142d4908"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc63ddc48e91008185e517a8f57f45831f8ddd4c297ae2bb2c2c34dd1d820d66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b15e2c11e1727c3a4ad11102f340ac803da8f4cac4528bd71d0df0e1c6fe58c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1a8487d573ea22f265d6c4ce997e88cbf02f1e7de7d3f80e555a329c0df30dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcb32ad69a4b9baa8b041f50f62696842935017cba5bc37700a4d640300e9c07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7135e7a994f1a16304005857b13a0f0a9237d812065896d9d3fb2376bf6d263d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "466120e1972c68a26a42cb400ea9ee621b7f4b1ee582e3e3dd73be8ed3bac46d"
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
