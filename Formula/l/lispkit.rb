class Lispkit < Formula
  desc "Scheme framework for extension and scripting languages on macOS and iOS"
  homepage "https://lisppad.app"
  url "https://github.com/objecthub/swift-lispkit/archive/refs/tags/2.7.0.tar.gz"
  sha256 "7ca8cd4639e6246884beaa2ca6e13746df6395b7bfe49b0de537fe57167a1dda"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "35b96c5f70b41844f03b783e45888018d0dc42905f60651b5349f627010bc53e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "208691b3a4a2938f07823686593dec6ba7b303cad19e5a154cf7af7a8d6b70b3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "53b20620a0a9a248a3276bff432cf09e3289404aab6e9afa2dd70b136268ecc4"
  end

  # FoundationModels `Transcript.Attachment.data` is new in the macOS 27.2 SDK
  depends_on xcode: ["27.2", :build]
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
