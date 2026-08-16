# Homebrew formula for hukou.
#
# Status: PREPARED, NOT YET SUBMITTED. The release v0.3.0 does not exist yet
# (the project is on a private pre-release RC), so `sha256` is a placeholder
# that MUST be filled from the real archive before submission. See
# docs/homebrew.md for the complete, step-by-step submission checklist.
#
# Local validation performed: `ruby -c` syntax pass and `brew style` clean.
# `brew install` / `brew audit --strict` deliberately were NOT run here: they
# would install hukou on this machine or need the public release to exist.
class Hukou < Formula
  desc "Household registry for your stray binaries: find, adopt, upgrade, and roll back the CLI tools no package manager owns"
  homepage "https://github.com/rtwsvj/hukou"
  version "0.3.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/rtwsvj/hukou/releases/download/v0.3.0/hukou_0.3.0_darwin_arm64.tar.gz"
      sha256 "c121c3b0d773a388b2998206ee748a8bb79f3fad59385408507131ecd7cb2a69" # FILL AT RELEASE (shasum -a 256)
    else
      url "https://github.com/rtwsvj/hukou/releases/download/v0.3.0/hukou_0.3.0_darwin_amd64.tar.gz"
      sha256 "33ac3d08562145611abe57cd568dd651c0ed9417e5efcd4021fac8a1733af660" # FILL AT RELEASE (shasum -a 256)
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/rtwsvj/hukou/releases/download/v0.3.0/hukou_0.3.0_linux_arm64.tar.gz"
      sha256 "53d5de46d2e554dba7d07273bcb7f39f6ddacfc0eb977333be50c8baa7846019" # FILL AT RELEASE (shasum -a 256)
    else
      url "https://github.com/rtwsvj/hukou/releases/download/v0.3.0/hukou_0.3.0_linux_amd64.tar.gz"
      sha256 "510fd70e2a16b4ab7c1a8dd8d20ff7fc7455b759a63c37f6062ab6f16d8eb887" # FILL AT RELEASE (shasum -a 256)
    end
  end

  def install
    bin.install "hukou"
    prefix.install "LICENSE", "LICENSES", "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hukou version")
  end
end
