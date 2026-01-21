class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "4b8a51b5a6c1d413f321721b10ade0e8c9bb0a70e8e2f05e6c58743cc57e12b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58cca2f471925fb12b02c17121649e35be291174e7ac0c28b98380fe831294f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc7595752d9328c0446cf5c0ac7afd4a5e5a0d85dd06f56c9b52df2aafb5ac43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d513acd7a6ceba0519368a42e3f13a411af1fb20ed7be8564e47845ed8fa22a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cdfd0741310e9cd82b7559a2ddff257e1f2330156f6ea071047549e3e4aa6eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d70dbe9880049435fc4b0bf03878f3d0c0dca2396f6df61429b61758f742ccd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5870a6bf24407adbd9f5b1239fa568373bbe09841a30db49d5f37f34063bc47f"
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
