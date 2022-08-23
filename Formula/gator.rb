class Gator < Formula
  desc "Gator - CLI Utility for Open Policy Agent Gatekeeper"
  homepage "https://open-policy-agent.github.io/gatekeeper/website/docs/gator"
  url "https://github.com/open-policy-agent/gatekeeper/releases/download/v3.9.0/gator-v3.9.0-darwin-amd64.tar.gz"
  sha256 "63b17b24d8a215e452b78e197625ceecd13665c079f03520bf3f0667966a744b"
  license "Apache-2.0"
  version "v3.9.0"

  def install
    bin.install "gator"
  end

  test do
    assert_match "gator is a suite of authorship tools for Gatekeeper", shell_output("#{bin}/gator -h")
  end
end
