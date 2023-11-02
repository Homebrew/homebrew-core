class Biome < Formula
  desc "Toolchain of the web"
  homepage "https://biomejs.dev/"
  url "https://github.com/biomejs/biome/archive/refs/tags/cli/v1.3.3.tar.gz"
  sha256 "bed6b68b0f256efbbf072c26d451e33923e4ceadb02032fe51683f98177038c0"
  license "MIT"
  head "https://github.com/biomejs/biome.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cli/v(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5315beedd7ba65096b1a011fd2a85d07803ceb1317c54a8c10e1c2d258eefc4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f88dda0218f833605eb872a3d0a7b62f6cd5c7f7febe2788473194d0cc06526"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b0c2a8ac1665258f45e83524971c124f55d9665270c9d212245e66c32a0972e"
    sha256 cellar: :any_skip_relocation, sonoma:         "80e75d851ca87439787e17bf556e560bfd979539d6bd339462c1632ab4fcf89a"
    sha256 cellar: :any_skip_relocation, ventura:        "935601b182b165b352d99ab40c499df4aa0f08d58cf857832b26a9d6b5e3e28c"
    sha256 cellar: :any_skip_relocation, monterey:       "aba50eeb731cda0c1b46a46ac0cc970f22ff77946d690a122dad0f730b7933e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867809a07f31bf2f23b542909cb065d2c69297c8d089127b3695a9fa646e151d"
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
