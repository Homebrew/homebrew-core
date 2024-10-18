class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.12.tar.gz"
  sha256 "c7ee9e8c35d0e8ec5203d12a022fd747b0179d1a7f83e3bc96b960ebaf0ec612"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "671a2283557c41991da3aa0ff73ff956d7273a29ddda725dd10a2683fb0853c3"
    sha256 arm64_sonoma:  "44a65b9c9ad3b98676b9a2c9d6437d267df430bb3558d3fa713d36074447cf40"
    sha256 arm64_ventura: "84dbb2e94b93bd231d5b316f2bd14443bf62cbcb7a09b025f2196aac01ec005b"
    sha256 sonoma:        "44f741c23c48159293ff99a279a5f0d230132a643e6e98108b02d72c58784968"
    sha256 ventura:       "a0f911f3ae20b073e1ca7b43ee53b33ef4057b79b4869a563329a259072cf58c"
    sha256 x86_64_linux:  "5ba8b442ee81d714ab2b8dba3ef89b26ff9bad883405313965811c2946ed61f2"
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
    (bin/"ocicl").write <<~EOS
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    EOS
  end

  test do
    system bin/"ocicl", "install", "chat"
    assert_predicate testpath/"systems.csv", :exist?

    version_files = testpath.glob("systems/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
