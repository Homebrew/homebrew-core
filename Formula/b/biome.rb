class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.8.1.tar.gz"
  sha256 "ad10bbc28fdc1f31f655eaabee42cb9358a869fc4433b4e8883093e211e9eeba"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8854de2e792c5b4d861eb084ea99f8debc1345fb080987cdea47b7b7201db014"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "421207a26cd3ea2fc13af5aea497786682146ffee3379be41a84a9257cd667a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82f280ffee7cd30a8ce0b6358717eea882f7d77e12a04119dd17308f71fed46f"
    sha256 cellar: :any_skip_relocation, sonoma:         "591e2ac2e36804b46a4616ed944f6b7e1217ce7425263dca5ad256ee4e9e4a31"
    sha256 cellar: :any_skip_relocation, ventura:        "ed41f2a8b64a733fd8fd5c1f84e7ecc82de9f190eae1e70a667cb19769b224fe"
    sha256 cellar: :any_skip_relocation, monterey:       "c91b9571b19e315531dd72f7afb1d17f17adcf960f63711d1d6353db30290e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09559f55fdc93b8d1f08078bbe7793418bf761bdef928ef5b1532b474bd94f6"
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
