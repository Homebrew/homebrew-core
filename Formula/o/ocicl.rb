class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.10.tar.gz"
  sha256 "944ee4d885fd016199496e743dcb819333c06f34351e88ad1e2bb9bd12bdd9b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff251474eea55d182d3a45382fb82775a85dffcf7a2a2bbda87ac8ce373ae909"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4425d1db8a3c940eea608a0a5226fa929d6d6dfa45fbfd265826dadef3b7b488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c14d2b71dfd04442ff0c4142c1c0ecd593798d626f49b27f41dd82f805fe6138"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1d9b1b281bbc4f2493fd0acba32da7c051039d03e42434755d94e6da55df659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b045150d1f763086c98fc1f2d76a4034af7b225992e0cb35951b7dafd56ed877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8990b2031b4669d628f27315ca748755148cf2a7bbd1ed308900849993002c28"
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
