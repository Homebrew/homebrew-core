class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "010cac0707f23860407e5f24317968922203f72474248474bcf94734206b60b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "616358351eff09cfc261ee24563b8b02ce77608a8322a7d6eeb924a380bbcff3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed499dcd7e8c31171abb5351d5bf1498a3e9bffc5403c0489db64a10b92bc9c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "428a0c823ff4121055778c38f1289dede4edf142441db5592bd2f9a8ecab4647"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23c8873f2a0405d8cabb337a7e6519de0bca2d438cad35a48754e375f2778345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2b7cd999ec0a3569ff888701935fd1a2b1035591eebefd043f168b92d7f8c28"
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
