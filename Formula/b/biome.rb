class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.15.tar.gz"
  sha256 "a6195ce3a4575ce316d2253517118f49edcd199a072880748e50170c6993e513"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a74e599fba384cc5b4cf2fd6ffb4c16c953eea63ddfb293b7d37ac67a469cbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2af994b39df07e89bcadcf4b1fb98f51543f5ba6d0a91d6750afa8382517f836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf6093db42a692938fd3d456bab2f0cd2f40c9c76a48eb3afa2f099ce9f3620c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f03c09beeca7943f6911170db358dc73e94c9daf69df7c12dfbb4988c867c59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c25157761b9cb7b0b7a485e450d4366458996b20509e37440f24c21514dce8d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ede13edf83e5a9a1818826ac7707df7d597ce7178004b3e7cae8d5c1f5bdf9d0"
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
