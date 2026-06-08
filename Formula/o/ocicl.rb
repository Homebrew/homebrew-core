class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.13.tar.gz"
  sha256 "067408f0443119a25c2b34a323a829fb953542e367bb039365bdcc0a0b388500"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a66bba9a715611e0f63da5689bc49cabfc9be203a0605b8ec9a88d85033d7a57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c88e599b0a72d4c6998290eb371aaf1d1f919060433c9dfcb099597ee973195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "231865da964148a4973fda68ce91a3fbe8579331d88b6a3996e00a3783df1ade"
    sha256 cellar: :any_skip_relocation, sonoma:        "516826df68588ea9d14866416241b0f544ccff19768b19cccb92b8d72ce4ea31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96ef4fc922385d2c80e75661a337980fc756031023efffad3df9d558d97239d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c39b4a1be6b0f5bd042266ca5e224508c3f3260bf757211cc54c77a908139de"
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
