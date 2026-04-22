class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.12.tar.gz"
  sha256 "605d6e85d6213bbc557ad3e504511bab3ae143ad5b7bae4a8476266c905a329e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2114127d3776d337165d0bfdad5650c1f1c456cb6d0543e30bdd2d3059a3a91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "433fdf93a795a23ca1e46b70ab9c45c8d503fb5cb6f9c7373ed0a66622ad3fe2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "589c15a8432c2faa8277473cd910fc756dfe7bafe3d4652c11b5dbc13e44141f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1ee0e8d9620e1f6122d055b332a513b48303fa7f77bf2268b8b3c8fe4dadd30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "927d326a8dc8366e35aba2c3e93cf425ef760a5bbd9f783cdcf39ae38d5fc48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368d4840b289d115bc9927da9f33a31cb9850bdcd2641bcc13c59bae6bd19414"
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
