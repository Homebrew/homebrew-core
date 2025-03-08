class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.5.21.tar.gz"
  sha256 "b98893cbf297ba54ac5c106bc8959d6100c9aaca505fb282a320431a6f6a6813"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "03b151490d80e1e76ccc6f2075d18538672ffd5469a1df04737bcd0d05ab2f28"
    sha256 arm64_sonoma:  "a1e33abce5ee1b7612b44d33bb6f77efa906e1115de1870748d9672ba475d851"
    sha256 arm64_ventura: "910b7e9b2ed1bd399b53d40ef7f4287a741cbd3b3c11b5f8e4baaf2149c40c43"
    sha256 sonoma:        "032e7ba6c7dc850e7818677ee43c8bcf3b3b963cc43bda57e251091a24626b49"
    sha256 ventura:       "780be5973f5588cea770b52cfb28829253e16f7037b9e3d8e71991c66e2cd5aa"
    sha256 x86_64_linux:  "93f953c7fc62ee3accd511e8d3942e1cb6c75e419cf7278be1494239932c5c08"
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
    assert_path_exists testpath/"systems.csv"

    version_files = testpath.glob("systems/cl-chat*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    system "sbcl", "--non-interactive", "--load", "init.lisp",
           "--eval", "(progn (asdf:load-system :chat) (sb-ext:quit))"
  end
end
