class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "c6a3cc31f457ad7999fe9cbee19e7a92443c046196ce7906aa06f10a8bc00caa"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "68cf5e4b035366f9375b2f53f9bb2802be6072c9d5ecd69b4c108766148e9c37"
    sha256                               arm64_golden_gate: "5cc632304706b30bb4145c52fe84f7fe5c0267982951013eebb98fdd8b3c2a8b"
    sha256                               arm64_tahoe:       "863c847d75c8ab3a9d6b27ff6ed37db18964936f7e6c1e51d4ec3f84690c94a5"
    sha256                               arm64_sequoia:     "e34e456ec2fdac987c88a3cc45db63ed4f2f2a6f00cc78ca54ec892a5c0c23db"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "333c13c6f63799f5d7a9d50bdbdce9309058ced16fb5baf9cfa344654af514e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2906e0e9c8efc36a15e66932fd7f8a7d8308837280ede6dda9b6b9931b51864c"
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
