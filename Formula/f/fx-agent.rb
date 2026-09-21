class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "59927f50a8fbc7567565e925463fd870682756bbd8983faa67aaff9fdd5d1eb6"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "672612b3619bd32b173188ccb7a81dbd22e409136141897d14c26c6c67f19ee1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b3455c98d09410814d18733b32dfec402f5f6a92eeaa862b0771d8abf9db755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b27139b287eb9b21f91a426020c819bd7812f0133a9b80ca1c6cc9ef9147041"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f04347850a6b748b83f855bede9b623033eaf750fc9f9554e80d6ace691dfd89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4ed7bb477a4d817cb5938c8378889a44839bf85f59e49849f1eaba9970cf3bba"
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
