class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.3.tar.gz"
  sha256 "0ecf4818c1a6a072647f6fcbdd29fcc2ac82b33ba825710806c7c7495edef20b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4f04edfd183eef881ff26ae9f4877deeef16d4a0ee15aa56c550d3566a8349a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b036ce640050f3c11a65e3151762a99e804150e6296df851bed4615b48adc5d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85a458db21529541ededb5c4a54dc9af34daa18c80e643657b3a10b1bdf70d19"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f92aa8e9d646aee9e107273a38ad9403c16c521c7a00f3f49392ac45471a079"
    sha256 cellar: :any,                 arm64_linux:   "7c495a4f818d54ea7ef423a43cc95ad652e0b96e86037eb8c0550d59910d3479"
    sha256 cellar: :any,                 x86_64_linux:  "7d1d4ef279f533a3c4516b87214c3c68a5b51b865216c5bf7b13fb83b6cf0de3"
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
