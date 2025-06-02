class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.24.tar.gz"
  sha256 "2a3c6b8c5d3e4fcb0da3f5796143a35aeb202215b56e7b7d7c2755f994d29377"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1bb1bd981e208790f38203f48c158140e518c4101c9ef9d30f71360ea9d136c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beb85ad22380226a56be468bb19d7230a859343ba09f2be844ff3fe67b9b9d73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d178da10eda76150f1251b096f6758b0797811da8b7aa36ee9f593ab4fd096c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ad70131e5b60a3f632fcbbdbcc11c5ef0d37ab5045d27d9a59d4b2f56c84f79"
    sha256 cellar: :any_skip_relocation, ventura:       "674cf47d7eedbf596728cc487c25168e5843de3a60db614e80ecfb193be9cfb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "494995ae34024e00fc0337d2f134005befbf481a823e0cb071e846ce0b017282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb38f3f06ae69989a48b86033bdc08742f3a1bd0459169d6be1b78026e3181c3"
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
