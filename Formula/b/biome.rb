class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.6.3.tar.gz"
  sha256 "a7172467bb0a15fa4c1138f5540493f8cb80297958b3d98ad80d18232cbb9537"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0814ea87550546e46b9ae0ba18befa1cf85443a78c4071d8f3f19dab9c8de7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32e098cdb1e5a98363ab6e8c74ed05cfb1617b8a22680bc5b5c4d353fe5afcb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baeb7cedac2dc561662499571fe2bfeb1ef7519844506a43209933d70475707d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec7c6ae0b21f967bd522cd85a09774075171d9670b8fdc7cc914c1fbc3b01139"
    sha256 cellar: :any_skip_relocation, ventura:        "ceb3d012e76028e4c87c789cb3d4c0a7e4a88aa2aefd7674c52ea6f0cba67701"
    sha256 cellar: :any_skip_relocation, monterey:       "6b20b31be8c72f554c0e36ac4bf706e871c86531bfd29d3d13d4de994e325439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fcb8b02dcb2b13210a544808ac6fbf3b69a97bad8251b63758e9a2892517b96"
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
