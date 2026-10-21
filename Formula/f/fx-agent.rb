class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "931b8d19098181e615e5f7ee9df55bbecd2065ad8a57db466ae2e95f5db3ffb0"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30100b5777070e83be140cae43bae560b75eee35ea44bff69e6fab8d8ec096a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6650c01e702c81d6990fd2ac0574cf3980e75e774a68039d49bad45b948eaa77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1dd791242841638cdca6080a1c07e6721872744033a4fe661a13ab202ed76eaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "972987189065c815ed314303383cffde6298d1bf614c0c167ceed0f3b6ce0ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ac3a9961f98958ad241191348939d0a0afd0b0a187b0bef7619dd950dd32d245"
  end

  depends_on "zig" => :build

  conflicts_with "fx", because: "both install an `fx` binary"

  deny_network_access!

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fx --version")

    output = shell_output("#{bin}/fx ask hello 2>&1", 1)
    assert_match "fx needs access to Vercel AI Gateway", output
  end
end
