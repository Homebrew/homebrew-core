class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.11.tar.gz"
  sha256 "ebc9b7868864842789d6c13d0ba44c2a62b7e26365d8a366f245f293ee8143a5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e378f8fdfce998e5c9063c9bf56738000f79b089ef6f63bec936360298d53b3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "168a6069379cf98b946f4af93408889b4341c1c1434bcfb01539ad5b416b168f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b0ca2856bc659abf8892b80b23c3caaa15b7ba71cf6822f649dd688135bcd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d9cec148ae73fe9a351db90d94be06a31e9343fb4b2c4a2937df4d56aef1c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c1f69fd8094be8c6ff984ea4c426624597b482acc30dfcd9d401a06fbf82bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e1d976c3f4b9e44af1a8a10ea0a7c86d3c4e63f7721e7c7c008a0a5688fc1d"
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
