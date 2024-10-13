class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.9.3.tar.gz"
  sha256 "031326783e528b18b3e6545cb7f8585342cfeae34ff0c15db146d32257bf5fcd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a0cc396570cb91fab6b4b9cfa2af88b6c6c3c30cfd1cd78f47cb8e6987e2358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "345ea4940cbedbd3d3c98bc8b7b6d6c63a8a56cac2836072a3b2780b63102172"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18ffa40b625492bc93dbcdb979a66fa9c79e64aad6c3132ff209e7b804c6e33c"
    sha256 cellar: :any_skip_relocation, sonoma:        "349f3e2329a1d5e9105cec2e482310479c048fe67118450b7ed16121ca0fb8d7"
    sha256 cellar: :any_skip_relocation, ventura:       "9ad7cf30ffbf1e8752858772e616afac2971bcf78ab46f2e1410e58f959f4cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5605ebf7ac4a81519cc28c09f7a69abecd37a34a8e3740f9d4c1a8403e8b9dc6"
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
