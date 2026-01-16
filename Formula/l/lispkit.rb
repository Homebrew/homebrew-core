class Lispkit < Formula
  desc "Scheme framework for extension and scripting languages on macOS and iOS"
  homepage "https://lisppad.app"
  url "https://github.com/objecthub/swift-lispkit/archive/refs/tags/2.6.0.tar.gz"
  sha256 "33ce9c6c4bd99e91308ec2a92c3850f6d63d373b8be2ec71d7e5b329fc6e394a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aed3fe5511491779f67507c14838f405e2d4b6d3a38df203f4fa8966065c2ea7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd42539ccef65523343d04437fa164e3cec899ec0e5cd44adcc9f1c3baed0615"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff174228531270ed810d4919b43e87ab9e65486133ab55ba784f23d44c929e4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e623e98acd76353cb32327f37cc63c10bc8a7fd7f764cd71c2a8376e98158197"
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
