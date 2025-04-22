class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.22.tar.gz"
  sha256 "78e378a84f96f52a0dd8518a9d049f94d2d76ee0c3ec7db1384104e45b5c20e5"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a562f9517bd3d70ccd9fd3fa9054e52e7da250053df3b00b021c25f03b67a548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66b0bcf1facba95a62177c13bc70682df24c86fb00a4d3804c3146dfe9e633c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e5521365471aa80ee6f490dff478adbc5ea4fbff649aaaafb1e8619bd4176c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e2758c6ca95630cc3dbffea3b0143e828a7871f52bdd66d657b3bb59780df23"
    sha256 cellar: :any_skip_relocation, ventura:       "1f087089c22627e1e3faabdd831002bb5dd30d8b18afd15af34726dac799dd32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b0de3e5f40cd1cae29a766af7ff26da10560f22f868b093435ac8f261d0b287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d6e9c0eb50771571bc5e915f7909450959965c965be730dc4380b5e7b0d607"
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
