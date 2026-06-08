class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.16.tar.gz"
  sha256 "9b663b3aa56da4a7103c124f183a2076816eb3d59e1694af5eff34962a237fc2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0e107a5e8079e404f834546143d53a63f0aa3e99a45aa8940a71513fa262cd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51496f6d1bde9ed12ce55de662ce111597d8735a2ea64bce6eb7f1abee2f699b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84003d77aa2fa53f59b5430108655bc05b4ed74bf041edbef7a462dd649c57a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6b299757180bea92a1de1d83d72556add3d596b0681d4346658fe0fb678582f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bd575921a6f2fa1a151f8f8cbb824b5e893cc51f2d3ee126f2d40c4e8cd8313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "438db26696d8b8cce086f65e829b14403398ee7582d2e0edd731495edd237203"
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
