class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "7199674fe545a0a80b1cf7aed9a52b51277beca3583c95478aae24e0c9af74f8"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "0efc2b941fe9dc75f9724b4d04b5d7952c985d545fb1b12b195eae8c054df7fd"
    sha256 arm64_ventura:  "a65d3fc5bba5b8888b25c873006c9727020ad57f83bf2aa1ce68ccdccd43c74c"
    sha256 arm64_monterey: "a5026cdbe0c0333540e05c76914607725ce458599f84af7ff10e4eec45d119c4"
    sha256 sonoma:         "d473977b6de2f29cb5a9bc4d89d83b371712f2bc3b50c046b4862a22b26800de"
    sha256 ventura:        "385609fb281d071dc635a20c0d27e477c14ffa413ba7ab4c634adb17899e13b0"
    sha256 monterey:       "4ab113ae47b8d01189149926515cc3011d56459d557a071e20bb957ab1f9c220"
    sha256 x86_64_linux:   "dec7d06ce409b938fcecc67ef38e30f7667a9d851952214862154a0227be7c49"
  end

  depends_on "oras"
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
    system "sbcl", "--dynamic-space-size", "3072", "--no-userinit", "--eval",
           "(require 'asdf)", "--eval", <<~LISP
             (progn
               (push (uiop:getcwd) asdf:*central-registry*)
               (asdf:load-system :ocicl)
               (sb-ext:save-lisp-and-die "#{libexec}/ocicl.core"))
           LISP

    # Write a shell script to wrap ocicl
    (bin/"ocicl").write <<~EOS
      #!/usr/bin/env -S sbcl --core #{libexec}/ocicl.core --script
      (uiop:restore-image)
      (ocicl:main)
    EOS

    # Write a shell script to wrap oras
    (bin/"ocicl-oras").write <<~EOS
      #!/bin/sh
      oras "$@"
    EOS
  end

  test do
    system "#{bin}/ocicl", "install", "chat"
    assert_predicate testpath/"systems.csv", :exist?

    version_files = testpath.glob("systems/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
