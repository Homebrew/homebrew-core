class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.12.tar.gz"
  sha256 "5889ff5d2cc386b07c8320bfc4a7a949d8b25e9e21c15cea3ea121337083a49b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48b63ba211fb8be6874bc5f8922adfc16fcf88067a747264f26b6a0f60176688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeefb73301c23462f0cb23caf76a31bd557729d73453cbcb6cdc0c5bc28b4baa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b1dc656f974d0804bf44ddf2a584e0848c9b4eafb16583c6b81ec77f4773870"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc66b94a8dc94198a08fdd0f14b302f2ddc989c11bc74874decffa6594678e21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "883134361b39f0c238293805020bd76007ffee95fcbd3af67720605d8d869eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d88c971e2831b30dee65f61a4c394b341630ff3736b581c4e1ef42e940ab0bd4"
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
