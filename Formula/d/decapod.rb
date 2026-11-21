class Decapod < Formula
  desc "Repo-native governance kernel for AI coding agents"
  homepage "https://decapodlabs.ai"
  url "https://github.com/DecapodLabs/decapod/releases/download/v0.158.2/source.tar.gz"
  sha256 "d3b3ee9ddbe34739b1ead32b31a42ee7511681ee9005a8e1a6fb5c2ba2101fee"
  license "MIT"

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decapod system version")
  end
end
