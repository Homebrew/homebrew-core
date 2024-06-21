class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  url "https://github.com/janhq/cortex/releases/download/v0.4.18/cortex-0.4.18-arm64-mac.tar.gz"
  sha256 "01c28d773c681572b911ed8f51c686d226b67efdfa213f103a78cab5f6f112c7"
  license "Apache-2.0"

  
  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "cortex"
  end

  def post_install
    chmod "+x", "#{bin}/cortex"
    system "cortex", "init", "-s"
  end

  test do
    system "#{bin}cortex", "-h"
  end
end
