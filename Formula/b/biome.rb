class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.6.1.tar.gz"
  sha256 "a74d3d874b37be751b9e98abab8e233863ebb34789889ca9012407b462733e26"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fcdab5e72302bbfe3d759b93294afbd491a78d7d2c5a9696f376f9cfb72116f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72c22ce572378b3a7695af483e74bc2c63a6a86c2b0ad35eaef4d60247186ff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "058173496bdf9882b1cf116684f047d1cebf7bbbf685fce07e9dfb673bead3eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c239f19307b8c9133b478730ce94cfeefea5196f293000cc7f553ded607a750f"
    sha256 cellar: :any_skip_relocation, ventura:        "6f9e3acb349ac675e18f2729942f0fc2cbff339db1bd3c24d210432453122b2d"
    sha256 cellar: :any_skip_relocation, monterey:       "74b54e5e1d8f8e5fff0a82bc756978b04278e6b344428646db62700dca2a730b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4e2e4959281511b553066dc6fc19671aaadac9ee56aff7c8741a65662c64ca1"
  end

  depends_on "rust" => :build

  def install
    ENV["BIOME_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/biome_cli")
  end

  test do
    (testpath/"test.js").write("const x = 1")
    system bin/"biome", "format", "--semicolons=always", "--write", testpath/"test.js"
    assert_match "const x = 1;", (testpath/"test.js").read

    assert_match version.to_s, shell_output("#{bin}/biome --version")
  end
end
