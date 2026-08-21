class Lispkit < Formula
  desc "Scheme framework for extension and scripting languages on macOS and iOS"
  homepage "https://lisppad.app"
  url "https://github.com/objecthub/swift-lispkit/archive/refs/tags/2.6.2.tar.gz"
  sha256 "d3565e3324a922d263e57a1ce5cafbc0c18c7788c4bbdffbb3a2ca403dc76f86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9da874f7996de48dc953b8c469ebd1673833a46144b07ba204f6658e7b98f14e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6212d81b74a4f41d3411c9efc408b048ee599604b2994f564d16ddd45a01944"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42831c30cd850e3991e0af6858c0aa04345d7e4eed7bf437b81eb36650b77863"
    sha256 cellar: :any_skip_relocation, sonoma:        "63fe455719a326aec886d5eb256448adece2dcd00b96bb72d55d2b02001eabbb"
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
