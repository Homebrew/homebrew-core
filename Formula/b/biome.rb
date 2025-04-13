class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.9.4.tar.gz"
  sha256 "fc06a89e1b925e8b1dfaca98f7af1d8e04d27acdcaeff786e2806f8bc26283f9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8646b6bdf4f2b0996e739aee80668eb17d32a7aad4a356986521d812cc984cc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43540d1b4f59a61da1b7baca7cfa5db8a1aeb06e9a0f0673e49dfcf214a31af8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb13597637d0123db60acc9e97cc4f08075f6734689d5e0a270a8a1ff419c756"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c37ee00fd5771d88747a57e6957b8c7a2df6901f8f58a1883b8a77e909b6d9c"
    sha256 cellar: :any_skip_relocation, ventura:       "b6c80a4f53293569e04d7c6b25b27535521ac75ce858b128f7c0070023bf5648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6373f7fa396319db672562c2581c2af4951a065c9c7a2465e963ca3e79f0152d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fa4e736896fa3289074b6eec6accff439ed4484e1d8ef909e03945a93a3a60f"
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
