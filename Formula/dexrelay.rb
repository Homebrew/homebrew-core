class Dexrelay < Formula
  desc "Mac-side CLI/bootstrap runtime for the DexRelay iPhone app"
  homepage "https://github.com/dexrelay-app/dexrelay"
  url "https://github.com/dexrelay-app/dexrelay/archive/refs/tags/v0.1.22.tar.gz"
  sha256 "e3c0580a490fa74a37d44b7e43717c45cfed9c7755115f8fcf5fc0ebd3fb7d6e"
  license "MIT"

  depends_on "jq"
  depends_on "node"
  depends_on "python"

  def install
    libexec.install Dir["*"]

    (bin/"dexrelay").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      export CODEX_RELAY_INSTALL_SCRIPT="#{libexec}/install.sh"
      export CODEX_RELAY_LOCAL_PAYLOAD_ROOT="#{libexec}"
      export CODEX_RELAY_CLI_VERSION="#{version}"
      exec "#{libexec}/dexrelay" "$@"
    EOS

    chmod 0755, bin/"dexrelay"
    chmod 0755, libexec/"dexrelay"
    chmod 0755, libexec/"install.sh"
  end

  test do
    assert_match "dexrelay #{version}", shell_output("#{bin}/dexrelay version")
  end
end
