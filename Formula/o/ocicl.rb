class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.14.tar.gz"
  sha256 "d29f7d405b16489ff8139b89fde762625545a6a75e95ac71a6755068e78c0940"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8918d189f24e6a1c1acf6ef455ef06d2eeadfdbe683bff4427e759f8f92b4ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa8b8d0e14a6c289b6457138934149eb0340a871b9cd2ad85c01f4dae6d56fbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b073d01fb8796aa0151b5c30536daab24f0ee8b588c47916229c037a2f93e651"
    sha256 cellar: :any_skip_relocation, sonoma:        "99728ca69d7e498bd1b31c0d90b099536801fd2d745959ce682ff629feef0fd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b5e61cdc92ac69fb0c0e4b20677365fe585678bc28ea97823055aa43f6dde1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4100286bf0fcede7dd513f25255a0cc9dc102d968342059ae49460448066ce"
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
