class Lispkit < Formula
  desc "Scheme framework for extension and scripting languages on macOS and iOS"
  homepage "https://lisppad.app"
  url "https://github.com/objecthub/swift-lispkit/archive/refs/tags/2.6.1.tar.gz"
  sha256 "0cdd1b64bbe5ec96ae02fca8cfc40a3758598e798a1e5c23238f33d5bd637476"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ca6983fde49101ea3b60b2284035feefb60c28608eda5e2649b7b518da99965"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a580e528ed918d163f1df9b76a31efc46ec0af33322f6a8addfae180d286695"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c88d9ca0fd00ee31d570421962b1fceed5903e3d5a3db35053fc72b3c49cb40f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a59b01fcf27bf43cdc301a739bac0724e539837850aed2dd14f66b7fab8276f0"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
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
