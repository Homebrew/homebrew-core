class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.1.1.tar.gz"
  sha256 "678f538b8b5696f94e0bb8ba2a63c2e5c785a01521b4b5ddf70307769a6c78c5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91840a7a79f07a3eb69221b27ff30d3b730c2be675e37748ca98bc501521d309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "107dd6ee26700ec4e4441b29f928be2b94731a224cea381812df6ef4a926e171"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43e000d2466f0e69711eb5f42b526640f4f47585462fd8b82281d2fb6a95af2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "928b9035ea5e3ab3dc04b5c386f80f2bb1a7c1787f74497cc0a0bbd4c2090bc9"
    sha256 cellar: :any_skip_relocation, ventura:       "432183936972fdb872e319f93c053ba4b256bb19e7aff13f49ce704d34288d89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86ff18f18c261bb404f022821a8b6a1556aa2fd708c5f6e4d589981ae7802498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "474faecb02d8765a1379486c019c1795e51db5e4078c52cb986ffb1c40f7fde4"
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
