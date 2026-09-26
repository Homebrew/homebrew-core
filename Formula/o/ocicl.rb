class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "c93441daeb9772922af5f7b394d60bbe44c67ea061511648943db07d33b5abb0"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e0bd87f6bd933300491d35341325bcf42fb7a6be1bb7ddfb4d6ae6172c03983"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a95ba0da65b62503b7cbe7233eabe97f0c2ecd5a47041e350e7b7e66fccb685a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33ba76f170d3498e57f8f8d9f96d68c0a040ad768c1b94b7e3d39cd9bf372be4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0fa246cddb41fd2c1b210c51a6d6855e535b672eb7afbf68cabd5a289029c8ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0f71115e66e9acd80860f84bb1230d9816c094d5bf9c781de6e4ed55e0957b6a"
  end

  depends_on "sbcl"
  depends_on "zstd"

  allow_network_access! :test

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
    # Parallel ghcr.io downloads get reset on CI runners, and 2.20.0 fails the install on any download error
    ENV["OCICL_DOWNLOAD_CONCURRENCY"] = "1"
    ENV["OCICL_HTTP_RETRIES"] = "5"
    system bin/"ocicl", "install", "chat"
    assert_path_exists testpath/"ocicl.csv"

    version_files = testpath.glob("ocicl/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
