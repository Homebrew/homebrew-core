class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "722ffe7bc0d2559d758f6ebdc803357c53d0fd47612cc498047aea74ca1a481b"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "7326c43203861c678e0831d570edba2bddb006e5deafb6e68c5c0808df14bbfc"
    sha256 arm64_ventura:  "2684110457171e34d40c656974525ae343e0436ddf82bb3fd05e5db1e3ac5cb5"
    sha256 arm64_monterey: "49c99736434593b71246b7eeba581c1e9f85f34a9d8546f84761005d6761213e"
    sha256 sonoma:         "1ebda17ee19e3705fb24e181baa6866e75eced589063fc4d45a138deebb6baf3"
    sha256 ventura:        "5e274dd71cf4e500c9725c2830f935dc7455035ef5cd01f26465e04c95e863bf"
    sha256 monterey:       "1b58751628c2ff4ecebef6227abf601596349552807ce83931705f4e20f51294"
    sha256 x86_64_linux:   "489ccd4945e213904eb47e4306ed07eddc3782269c009967caaf4264df751417"
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
    system bin/"ocicl", "install", "chat"
    assert_predicate testpath/"systems.csv", :exist?

    version_files = testpath.glob("systems/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
