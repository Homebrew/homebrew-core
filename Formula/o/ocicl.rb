class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "3310802143004b784bd229f67c1c264788e9e537fc4ea787bdeb186eb017f5bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b43497043d6f5b5ef74dd18a715d15387b83de89d0ffe4251d36693c119c042c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1429f64417f1563fea2ebf7943a08d72c8f403274130b56e2028c4127df642ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2fc2c63d5d44b4b82cde10b3a0859d94f8d427a6fdc0f6fb68e7a2055659903"
    sha256 cellar: :any_skip_relocation, sonoma:        "62e5273058c59db327f23ebd1c17b4c3c0a83f281e3c3c79dd77ae696f8e0618"
    sha256 cellar: :any_skip_relocation, ventura:       "06a1249400562929f96fddf7f1204f9e1b1f279b793a27710f5a1957f281384f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e80ce157b212971af137b5f69a7b293d0fae43cf529cf8ad0623bd9085224010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b702c18680bf105a49d38536941e0f47db16ec341868fc94a4115fa46ecb5ea"
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
