class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.6.6.tar.gz"
  sha256 "2d73a6818b1cb963b15e03c259d12cc04c4fd6a11818e674087dbc97e3a97648"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cc0f9f5f06256fa2208fa81a95d31583ecc3d4c3fd82e3871e4ccc5231cc63a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f4a9832fc5df493d245823cf1a4346db6494e79626d75a45ddf19d103c238d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96a113f156e1c0c5ec47bfd0739bb22dc7b19865f684d366dba8c963416a3c01"
    sha256 cellar: :any_skip_relocation, sonoma:        "51bba419d08d7b6914fbabafb87942295a50bec7d0250be0067316d6bf5cf327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0197598eb52587926579c73b7fc05dc96aa5ce7c498ffea026cc3864cf5e095e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c36fe1e22417ed68d8bee580f60c3e50536492c8c20668970e2da9d5713eff2c"
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
