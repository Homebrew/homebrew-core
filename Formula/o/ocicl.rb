class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "b9e6b8f6fc0af6b82b9fb7a9823931c068c3bacdec7375c364c2ba1914101bd2"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "84068edfdc7748ae03ebca73f230efd0359a37575be06a06fceb9a721d6c64b7"
    sha256 arm64_ventura:  "525b030c71672c40865dcf93d97540f81d56ea51a388edbde57829154e4b4fc5"
    sha256 arm64_monterey: "ab26ee026a2656a8ea32c2761d8074bb1e93c3f48cf54296df4a5c7bb6f5eff3"
    sha256 sonoma:         "bde9ef393b899c8ef1514ee7370c1a237c098fcfc9921ff597b2affe60f25606"
    sha256 ventura:        "8723d944157f4558cc448f9a58907d7c7860764ce36824e5b06124929b84b785"
    sha256 monterey:       "681ddbc2f853a3e1693f3f378cc57c18900afa173ab4e8f0e200d1d09982a093"
    sha256 x86_64_linux:   "fe9b2d51c012851588baef450ff39b453526a7fc2c5df38e9071fc253b136150"
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
