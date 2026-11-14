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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ac453e10b501d201fa334b505f98404e94a13dbbbf1e7eda357a1d4c4540a904"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6871c028072aa2dd895cc21a033a4e9c698b22b9dd158c8cb6645d61973fbd41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "302da4122c070960f4e0b611d92842254bc57b545b013f2d7c0ba192097b1f39"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dc713a03e6ffa5cdf3882b18365e3c151ffae02b196ff8bd4ad7774317aff634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ad4aa774c4188745ba6f33bb67ff4ae228504967aa76a255d3075a5674043e93"
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
