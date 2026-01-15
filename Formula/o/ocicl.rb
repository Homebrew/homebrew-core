class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "640f1a45a4d9dd2575307ec2b5776784bab637098b90d6d01b19a9cd958ba128"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fad2955cd76862240b7f4992363c1d86621e4bae06096a6edba4aa532da63fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4068a6aedfd0a043b85213628d275a87687f51d069b8b4614c2c1054dab66b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90aa3c2ae99336f5764b11bae9f956f335e1e64f85e1fe48c803a22a79a6acb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff2204766734f344109b7a5b0b4f3929fb502e065584f0c179b182fe948fb405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88ff7489443a0f080c11514dab424b8267f7584e0f09d97b9ae3c58f69cfd59d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d6dea35b226b83bc04351866c4827eefb1ddfe9c61b73ab984c671d6c27613a"
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
