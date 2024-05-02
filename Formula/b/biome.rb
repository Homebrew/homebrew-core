class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.7.2.tar.gz"
  sha256 "2b3fcaf4d3cd23788dd0cb9a85a401233f1c53e15cd0b8a62a5c47c2ae9f64d0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3a7417a27bc25a454d4aff19beb22640b643b096e3f2b0dd6b6799e4d487b17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dfad7f4b66255482041fa3116b6043fd03a3c30f6eacf19928977ccee7cc47f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc85aeef094f878a5bb36ae1521a7aeaccab4c08077aab515b6313b224c840ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd225deae197fb4ad30ff9eecf4ffe669a9b8933f983202de0132a64279972d8"
    sha256 cellar: :any_skip_relocation, ventura:        "8c5dab15a3e7a2554c29f1cf884809c09c551f57a492520b51f5fd7663329b67"
    sha256 cellar: :any_skip_relocation, monterey:       "19a8e466dc3379d10c8cc650dd2f1a6aba33280663685ec72ccb3e57db941051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5617661d92243e058705f335e996a1b27ee5d12c4dca4c1f9c88f3b9b74299"
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
