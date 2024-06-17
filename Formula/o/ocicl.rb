class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.3.7.tar.gz"
  sha256 "7199674fe545a0a80b1cf7aed9a52b51277beca3583c95478aae24e0c9af74f8"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "1ad6a27c4493dbfc357a326d591b0fe7b84db72c949082d63bdb30fc307890f0"
    sha256 arm64_ventura:  "7fe61e9d93f5328d204ada7fba3e83990770b99e07e38db560c641498c46ba87"
    sha256 arm64_monterey: "c8d89c4b706e9bf8a505b73c5eb4b7a822fc60c302554b7ce06cdb849677eddd"
    sha256 sonoma:         "46a7905ff3c8e1566d1327b7abbb184b4c2a49e396330d951538bcc97a5a62a8"
    sha256 ventura:        "7599b1cf1dadb1f6e0e5f38701b3ddbefca3f9c8a101a667c5f30790e647b7ec"
    sha256 monterey:       "aab6fb9a731d26d4155b7a8db4c6367706439985191e5a33b1d262f0f925cc86"
    sha256 x86_64_linux:   "9d55d3760b24297104b7be424e844ea7589640bd731f836eb31afd8e915ff17b"
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
