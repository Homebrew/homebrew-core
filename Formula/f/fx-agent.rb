class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "54c16e60ca2ec2d2428dd5806a4967bbe58df29a67dcd2daf948b6af24167753"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "134f9c9aebf68e186e0561d8179889e7e5861c5b8b20788c2443e4939a358863"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "582e431caa02f34e91ee3d6518443f49db8344e199ea59b92622f5ee4620722d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a49fd6867638c38ac2ecf19a5e5202e3209ece7d856cd74877ebe3292aede652"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9c725e164844340b8db3a04d81de7ab2ce3463cea1860880f5d9883caf20eb37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4dbd0b5c33155cadbb5313d9de6c255125c445cc18bf72a3b769ca5859b13f3d"
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
