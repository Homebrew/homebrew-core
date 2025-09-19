class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.2.4.tar.gz"
  sha256 "4239fbcb799717215c8cb204f2f90bc38ef7e118935fb72cddcca51046c1e8fb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a32c68606a82c5395e68bf97f2edf380f06afd9f5cc51df17afc335bccc7e049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca8205a0a6111799b80fb9c0e5a2b5773e2bcb0e016a4640f2a8d7bf384d1c3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f7f94025b6ebd0e824ea0515b2d05d4f412100ea64247d805bff75448bcd1c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41ceb3e92e91e5f6ae5af68a74007002ac19c6085768bba14526e33bb60aac6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f620dbe5bec648911bd9e7732b4320ea0dacbebeed8f17286174079be8dd4834"
    sha256 cellar: :any_skip_relocation, ventura:       "5504a3eeff55d72f8c8c1c0cae9bc7278d3aaf163bfcea2ce02853d0498f7ecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c38db5065ac3e81c18c6be421cecf41790bcf2e12b539fd7b9b56d7a012f3a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccc94e3441d62c3415483a5141b37cb3e4dc32e98d3e119217610a39a047e870"
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
