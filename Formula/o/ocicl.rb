class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "a6d84d52d7565a24cfd80c5f65ad1addd9200b471de9d7cd7c6d5c48ddeddd0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eecfdc8400e7c7c16453cbd9b6e8e724a373298fe226e7231c9e4e631aebe8f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d95267c44309ed17fcdc8c175749ae718cd5b7bd26c5c6a716f05f877e08417"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "534b7b663a474d075dee7fe09e4644b2860932c815fed53f5b874f0e04968cf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c8d62dd174922ce1c84824a8f3897acf867316632b836c96b0bc0be864c3bf8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "081eca09f56c3d943b74a220fe30330d05d63e4c574b623d1b10d657f1d14918"
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
