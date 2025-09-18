class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.6.5.tar.gz"
  sha256 "a4cc0055e66c948dce070c98067ebd445d55bd3e349030e819547dd203d5e75b"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b68642b17bd01852ad57f92a8b550d9d7f2e0d3ae24f6068bbe65c5c80ccefc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "298c0f2eafc32c6c4decac4cf8bc97bb2cd3b371995a883f842ab664eda7ed40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c41df210c1fed81aee61fad7661278e7137f7ab4bc36aca50af28403741df228"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d05d39063018f6448b737f1ce01c274f871ecc0162fc265746c10a479facac18"
    sha256 cellar: :any_skip_relocation, sonoma:        "7736bd1224e48458cc5c41f248100bbf2d556220429c510c27679bd8951cd360"
    sha256 cellar: :any_skip_relocation, ventura:       "e36de8ef5a2417d25dbd36456eafc4672f1296a199e3f602869660c8cff0730b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ff72f711720ab92f7f898ac0cce89e78efe414f3429e5d9d0cadd9b282d6423"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b678a0a07798c88f15d8886bac42657926915738efa4daa6f180b60e838885c"
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
