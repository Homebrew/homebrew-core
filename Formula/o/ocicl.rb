class Ocicl < Formula
  desc "OCI-based ASDF system distribution and management tool for Common Lisp"
  homepage "https://github.com/ocicl/ocicl"
  url "https://github.com/ocicl/ocicl/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "4ed3f547768d412f7910e3ce2d1067f8fb426a4de65094ed748078b7e59375a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6c29b386792da25e79ce166c8c78cc3c48919c6a19250927de7cb9615d61eab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5468e8075a3fc51713d1a79187e5cb68f58b335ff5f981fe99092291b27240dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "228cc5f62eb4a9dc8986224472cd56050b76f7e6f9805ba79ed19b50cdda569c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "08df89e228e752fea2e06056877249e9e53038990b350d6938b4851b38b65ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "30a1e510f8cf8b64b19f6fbddd0cec6ffc8d3f07c833ffe055fdd032d23b0ce5"
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
