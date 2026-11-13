class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "4ed3f547768d412f7910e3ce2d1067f8fb426a4de65094ed748078b7e59375a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4a9e7367c7c03c4368ecce8d10a622822578ebfb4e121fe90693992e82a8ff6c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75b10389427263c700a67571f55096ed1eb8eee65daebc9aedb1a2766de1522d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2aae3f91ce22fb368eed816ab6ec820aca0ff4bba237bceeca8ecdc53800579"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a922be7671b55c414c6b45ff050fb8fedac20ea9d70a387f6f3a49f4ad677967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "42564dab05cc0c56b22253316d973c49d092f52a81a80cf125428f55d9b1ab20"
  end

  depends_on "sbcl"
  depends_on "zstd"

  allow_network_access! :test

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
    # Parallel ghcr.io downloads get reset on CI runners, and 2.20.0 fails the install on any download error
    ENV["OCICL_DOWNLOAD_CONCURRENCY"] = "1"
    ENV["OCICL_HTTP_RETRIES"] = "5"
    # Install a system with a single dependency to keep the number of ghcr.io downloads small
    system bin/"ocicl", "install", "flexi-streams"
    assert_match "trivial-gray-streams", (testpath/"ocicl.csv").read

    version_files = testpath.glob("ocicl/flexi-streams-*/_00_OCICL_VERSION")
    assert_equal 1, version_files.length, "Expected exactly one _00_OCICL_VERSION file"

    (testpath/"init.lisp").write shell_output("#{bin}/ocicl setup")
    output = shell_output "sbcl --noinform --non-interactive --load init.lisp " \
                          "--eval '(asdf:load-system :flexi-streams)' " \
                          "--eval '(princ (flexi-streams:octets-to-string " \
                          "(flexi-streams:string-to-octets \"Homebrew\" :external-format :utf-16le) " \
                          ":external-format :utf-16le))'"
    assert_match "Homebrew", output
  end
end
