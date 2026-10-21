class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.89.0.tar.gz"
  sha256 "5e1bc3275ba0c5f6dd92aadaab9f5303062d4468198bab979746458ef59599e3"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f40f6ebaa2d0703bc39a08d9433bc738413140e5c37575dc511de6df1d6194c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b343424c27b7fad3b8cf4d39ed733e6c98ad273e39e9134f85b26807c50b5579"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2756b32080d7f48de874e8eb0de14d1749c0425ef3d984da737664d6994cd44f"
    sha256 cellar: :any,                 arm64_linux:       "356076cc36535c532f0047c1c97e946755f75bc7916ea8ff91e3bace87076b0f"
    sha256 cellar: :any,                 x86_64_linux:      "8417672c26cc6998ef2a7c57da3fe143f360d191ddf0b267317edbcfa7c559b7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
