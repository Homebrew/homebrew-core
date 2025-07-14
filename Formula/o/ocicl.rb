class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "a4cc0055e66c948dce070c98067ebd445d55bd3e349030e819547dd203d5e75b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f1de1f5442d17d99fd9dcfdfc511c9b5b96db3d7bb02fce07cd85b231927465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c64f1f99216ce0346448f25cafbf14d05cdb689a99aabb864370e884092b722"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e455c0561c5288443f8e1282b37ee715944dc7f4417fee1b5b17da6bfad2bdb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "32115223fc4ee9b859a985646b059344ceb9e549d5080bebc9aaf34c53c8fb31"
    sha256 cellar: :any_skip_relocation, ventura:       "2ddeeb395ab4a8152d6a91775bff2b2f7c0cb2fcc3a1d9508fdea79304258047"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c139418ad04c29df0ecf95df6796ff0847d5d259c660f9318cc84ba14fbb907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d806b3e480774420b6007a83ecdff094270716c2d4907ba8fbbf53156b1c7533"
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
