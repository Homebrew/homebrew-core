class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.6.tar.gz"
  sha256 "4b51310e5e2ba9bd67c86650f681498205d3eeaf57f2776c248190149d09f4c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3355a9b9da346e076d61068bdec557d1d435a20db798e1214d3bbfd406a66d98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "940b5d9dfb73f77a9abfebdcad0bab022af3527651e37ba38b7a81df548a6234"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "897ef0bc9247f708270d7d1a9468022617a2b219b52e16d476e858d0942fd769"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a72baedd5bc87e2b5521081712a79590f7cc26a385955f689a47a8a64ce7ab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fe0841d70e21653f51d6d9171a5873f0dd0febe246edde232d36edf20ecb629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c08be776b48e8da7eaf494574eddf961664c2820153f7c15d50227cd1b1c269e"
  end

  depends_on "sbcl"
  depends_on "zstd"

  # v2.16.6 switched to pure-tls but dropped bundled transitive deps
  # (trivial-features, usocket, bordeaux-threads, etc.) from the tarball.
  # Pull them from the prior release until upstream rebundles.
  # upstream issue: https://github.com/ocicl/ocicl/issues/193
  resource "bundled-systems" do
    url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.16.5.tar.gz"
    sha256 "640082be5b7e4669bdf996ad7203a625076badfb2927ea296cb625fb00807df0"
  end

  def install
    mkdir_p [libexec, bin]

    # Restore missing bundled Lisp systems from v2.16.5.
    # v2.16.6 dropped transitive deps needed by pure-tls and drakma.
    # Copy systems absent in v2.16.6, skipping those with a newer version.
    resource("bundled-systems").stage do
      existing_prefixes = Dir.glob(buildpath/"systems/*").map do |d|
        File.basename(d).sub(/-(\d{8}-[0-9a-f]+|\d+\.\d+.*)$/, "")
      end
      Dir.glob("systems/*").each do |src_dir|
        prefix = File.basename(src_dir).sub(/-(\d{8}-[0-9a-f]+|\d+\.\d+.*)$/, "")
        cp_r src_dir, buildpath/"systems/" unless existing_prefixes.include?(prefix)
      end
    end

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
