class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/@biomejs/biome@2.5.5.tar.gz"
  sha256 "0a455213a84df7bfeabab1620c3ab6df99707792af429bcb3ed110b3a110df1b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^@biomejs/biome@v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b1d54e39d7f1e560a7984faef297d09f50c1c4a87e17de3da0c649990170b48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3ba23cafa767098f3ac1500a281317fbbccb280d4ca7191dbee7c3ffbc2f618"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be7a2434a0e4d796da5c6de7f843f41c5711b3196239d1717cca77efbfa8489e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7b07387cf8c696d62449df46638a4ce515382f063ca9ac48d0ecddcbc63dfc3"
    sha256 cellar: :any,                 arm64_linux:   "33b9f0fa8f660aec4babb37dff2c728f473bcf6b9ea83f6ba3ba4340ceb652ca"
    sha256 cellar: :any,                 x86_64_linux:  "adbdec146b8a0ca8c8b1081eabc2cdc4ffbdbb34dd26e256144cf8ba93a8f5f0"
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
