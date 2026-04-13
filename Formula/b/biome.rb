class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.11.tar.gz"
  sha256 "175d99de291dd4e9c91fbb6bd8c3ae1d976bfa82075b5f19a314e3a4e58e49b3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9e125933ee1176bb7bf34f6572c013b23ba60f773747e23275153762483a034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1c5bda0edd6eeb602fec1f0aac27f77e0667ccc0050d4260c6844548aaced3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3ecccb1b945be3bc70c616b9e5a78e811fde8fefb073a27c75b9a209611a38a"
    sha256 cellar: :any_skip_relocation, sonoma:        "37514a62ddcddef79a486900c3acced7a1ddf7176479ed96eff10262771cb494"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07b52a585eb5c0a91b13c154a7c9f87470d1fe7657314906abfa56e6ef01f613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cc912ce156b1d782cb3f2a53920b9a60cf3873fa729276a812f4e49da915532"
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
