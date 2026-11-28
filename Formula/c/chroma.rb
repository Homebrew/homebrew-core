class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "60b3bb6d6bb4a8e825b070a699bb8bc1ee71afe09a1e68f99ba81c74a9c068c9"
  license "MIT"
  head "https://github.com/alecthomas/chroma.git", branch: "master"

  bottle do
    manifest_sha256 "e53cc35ea65f0ba1561a8274d5d8e21f859075515727e0c47d1a1daa09e26339"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f49634a67c0f8aa1bcb14a1fb5ad867c4b57707b10a92d90079afbdac2506f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f49634a67c0f8aa1bcb14a1fb5ad867c4b57707b10a92d90079afbdac2506f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f49634a67c0f8aa1bcb14a1fb5ad867c4b57707b10a92d90079afbdac2506f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a849f66a515b8e8c394a914fd32bb102793a52ec7c8eaddcee6930629231b833"
    sha256 cellar: :any,                 x86_64_linux:      "d9bdf393388d91ddffd46d9ac17dbc50689beae572854580b5d6c63050ac06bb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "cmd/chroma"
  end

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
