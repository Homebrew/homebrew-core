class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.6.0.tar.gz"
  sha256 "8b4e8dc87affa5a1e99dfc90fa0ee34232e34b7bcb9e7b4cbd51c23ecb6a3cc2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "419bfbaed65f4cbc173e24266097f68814d261d1b0c2378166f06a75a19ec9d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbdf0b1b579800c47cf32964a6c3dc1c717988fce4138e92aa268b10d9cd11b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8c74ab07c04b5b50120ee8ae451cca502705519319a878e232548152c6d472b"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b2b8a0b2e1e74d222bcc4cf91bb00ce9adf0e043ad471bbef4bc4d5d3a87a81"
    sha256 cellar: :any_skip_relocation, ventura:        "135bb8db64b4901e924aeeb5d97fbb095733c5d0836849c8e5afb91893267c9d"
    sha256 cellar: :any_skip_relocation, monterey:       "b78b134fc875bdac74dbfac6e2a94c9947c6e8043e1ced9bf56f3d6a8d381998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994aa90e786896a22b28c17e7bd2626a369d1054aacc6da8ebb9d6e520e757e8"
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
