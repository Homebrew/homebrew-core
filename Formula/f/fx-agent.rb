class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "f30e539ee943a5c70d3ba8d15f171e216798e0de368cf38eb7a90483e5eba582"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ace185fc88d19677fd4ef395e0dfa16fda3888ded577aadd3f3cda413cacc811"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b77b09e4e60b1d787d9f1f4c163a4fa445bef413c91629e33f24619cdc730ee5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d540236be76c76f02a14bbbe3ef4bc591e03947c48c47d6f553a41278c17e57"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d22d79305050ec901b0d479529263a0f9f871e10314840658776ce83538f9a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e00ee01560efc7ae044fec18f26d173343660e339238c895a65ea1806388f155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b5ebfa08877cc234674976c9c054edecf915a755dcd0cebadcb00137bb42631"
  end

  depends_on "zig" => :build

  conflicts_with "fx", because: "both install an `fx` binary"

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fx --version")

    output = shell_output("#{bin}/fx ask hello 2>&1", 1)
    assert_match "Fx needs access to Vercel AI Gateway", output
  end
end
