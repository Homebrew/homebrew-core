class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.13.tar.gz"
  sha256 "ba28c9dc813fcd9f519a736daacc3362e6e4780a33f6fceba9b25fb0fdef35a5"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "cf6e754c0940d82cbff8f01f33f604f9f48bb1b4f80781a363666c11b25bce73"
    sha256 arm64_sonoma:  "b2c488e77ffc5cf9b696c8513dfc67bd5521279e79206a56a159521b111a48e9"
    sha256 arm64_ventura: "86ee3658d8eb4068b604abf947431675add3148e21e1091153180beacf8c5b6f"
    sha256 sonoma:        "4bb1709d90211a048eb3fc26fe3a3a74978093fe373a485f3a1453ae11d4c515"
    sha256 ventura:       "5b7925326586950f52e8f6aa716e9d083fe7807a186fd22a37600d70e4b88e23"
    sha256 x86_64_linux:  "a7e8f6e5d2c479096d596ba32792dd85613d11ea318e7ffcd330a3ab1fc6a561"
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
