class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "c06e0891c9b3d6e58aabeeaac907a100329645a5f73d34797b585046bd3b9c4f"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "868705dc6d56812ef11a65338a5189201a666d07592fca056797edfd84b9290e"
    sha256 arm64_ventura:  "c9b9bd7fd62ad64e41af5ce41366272099fbbd6e3db31438c684943cfffe3d7c"
    sha256 arm64_monterey: "f90a4d359badfcce5c2e08b85388209212f47ce807b8dc77238f5d79738fcd73"
    sha256 sonoma:         "7749c25f20111f4a2f63e644bd944f4137586f505d7ad798ff9a06d0d5925b34"
    sha256 ventura:        "081ac94cc8d8d4c5de41d851bd8cb742eee8e8b28abcb54419c443e18cf9cb22"
    sha256 monterey:       "07f470b507c463cbbc8ea90c23e6b70f8802691b835397e99fc7ec9d2d2f9a1c"
    sha256 x86_64_linux:   "33b3c1b83795a2317c1668d037628bd6e05494ebd0c21aaa24fcb73034101cc5"
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
           "--eval", "(require 'asdf)", "--eval", <<~LISP
             (progn
               (asdf:initialize-source-registry
                 (list :source-registry
                       :inherit-configuration (list :tree (uiop:getcwd))))
               (asdf:load-system :ocicl)
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
    system "#{bin}/ocicl", "install", "chat"
    assert_predicate testpath/"systems.csv", :exist?

    version_files = testpath.glob("systems/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
