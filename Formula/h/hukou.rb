# Homebrew formula for hukou.
#
# Live in the rtwsvj/hukou tap (brew tap rtwsvj/hukou) and submitted to
# homebrew/homebrew-core (PR #299130). The four sha256 values are the
# published v0.3.0 release checksums.
class Hukou < Formula
  desc "Adopt, upgrade, and roll back CLI tools no package manager owns"
  homepage "https://github.com/rtwsvj/hukou"
  version "0.3.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/rtwsvj/hukou/releases/download/v0.3.0/hukou_0.3.0_darwin_arm64.tar.gz"
      sha256 "c121c3b0d773a388b2998206ee748a8bb79f3fad59385408507131ecd7cb2a69"
    end
    on_intel do
      url "https://github.com/rtwsvj/hukou/releases/download/v0.3.0/hukou_0.3.0_darwin_amd64.tar.gz"
      sha256 "33ac3d08562145611abe57cd568dd651c0ed9417e5efcd4021fac8a1733af660"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/rtwsvj/hukou/releases/download/v0.3.0/hukou_0.3.0_linux_arm64.tar.gz"
      sha256 "53d5de46d2e554dba7d07273bcb7f39f6ddacfc0eb977333be50c8baa7846019"
    end
    on_intel do
      url "https://github.com/rtwsvj/hukou/releases/download/v0.3.0/hukou_0.3.0_linux_amd64.tar.gz"
      sha256 "510fd70e2a16b4ab7c1a8dd8d20ff7fc7455b759a63c37f6062ab6f16d8eb887"
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
