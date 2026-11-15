class Lispkit < Formula
  desc "Scheme framework for extension and scripting languages on macOS and iOS"
  homepage "https://lisppad.app"
  url "https://github.com/objecthub/swift-lispkit/archive/refs/tags/2.6.4.tar.gz"
  sha256 "89e19cb34aa29aacea67a33a3187abf854fd2a5d0d0c608e59f50ba2073e2f5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8cfd449fcfdb274a8633f4b1808c0cd9d0708f320f30c71138cb6c70b1849ada"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ef5bd9698b8c13705b15195ae97a7bb98379b0b4d5200d502849cea29a875a2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0e9190160fe1df00ae9be606f56673c70e5719c935516b4db5a718c0f1256a6"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "swift", "build", *std_swift_args
    libexec.install ".build/release/LispKitRepl"
    pkgshare.install Dir["Sources/LispKit/Resources/*"]
    (bin/"lispkit").write <<~BASH
      #!/bin/bash
      # LispKit REPL wrapper script
      RESOURCE_PATH="#{pkgshare}"
      # Check if user provided -r or --root flag
      HAS_ROOT=0
      for arg in "$@"; do
          if [[ "$arg" == "-r" ]] || [[ "$arg" == "--root" ]]; then
              HAS_ROOT=1
              break
          fi
      done
      # Execute with default resource path if not specified
      if [ $HAS_ROOT -eq 0 ]; then
          exec "#{libexec}/LispKitRepl" -r "$RESOURCE_PATH" "$@"
      else
          exec "#{libexec}/LispKitRepl" "$@"
      fi
    BASH
    chmod 0555, bin/"lispkit"
  end

  test do
    # Test that LispKit can evaluate a simple expression
    output = shell_output("#{bin}/lispkit -r \"#{pkgshare}\" -c \"\" -b -q 2>&1 <<< '(+ 1 2 3)'")
    assert_match "6", output
    reported = shell_output("#{bin}/lispkit -r \"#{pkgshare}\" -c \"\" -b -q 2>&1 <<< '(implementation-version)'")
    assert_match version.to_s, reported
  end
end
