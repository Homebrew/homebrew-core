class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.3.8.tar.gz"
  sha256 "46610aaedc46c5dbb0a66a971bac75b714d62be335667de5483d9901dd34de97"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44875bc6c322ec8dc342c0b034905de9d137beb2f798444e8cb979f184c53d1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c08a8154cbabfdb3a07c407ec1f8bb15ff40237ce1ab379b92770cb93c2a5bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3879fff0aee5dadc74239a49f21697ac96292eb34f7c7c963d96932de2a690a"
    sha256 cellar: :any_skip_relocation, sonoma:        "33e2a796abc1cac04a5be1078990be978226e88d6fff0285947fce2749edb755"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b8cba92f2a5067e7bdcd155a65e4281463895a794284516a4cc85a6609e727b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f45cc894701b2349800015e459acd3e2e6906b6615f9ba5053c9ea5c1d08639"
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
