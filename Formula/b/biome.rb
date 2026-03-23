class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.4.8.tar.gz"
  sha256 "1600ed6c4b405d385929e34b678825129096be605dfb834ce7aef57011274ad4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3ac478c9cefbe16c2edfe924263a68a91e6a832e0a736cc2b1fa6a4e193a3a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e3a1faf2ee6c0a994ddba6128339903eeddf01829ef84c4d9e846f85c647fda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae2d0c47461265adabaf5d9dadb22c2c2f886b12610072741cfbc504efdbf65d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f025e5a480682cd057d9de83a9eccd04b937c79fd888db424599fea6de3636aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41ecd7d2d935dc7b16573898b54d59a00a873ae0d0f471dcaee1d5757e3c0dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "084db941a3e09f82d1f2b093cfad87b8cd5769b8fe464e5bc48f34198df177fa"
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
