class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "0de73fc9338eb034a0c2bdbda72880f1de12ac0bc686d814beb1975a310264fc"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f762830305f84a52eaf6920d414f2f81ddfea074f2702e774640069682dddce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "939602d44b2a985c4bb4b8114e9f31538738842fbc4d7b9855d4fd58c2952298"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7b8b4a59d26dd8b62caa25432dc203e5c1b394d3fb81b61bf3c3b1d7218ad9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "068bcc3fc81f2608dfd837e3eb4561213953fd1a6c96c1886f5d23871a1d400a"
    sha256 cellar: :any_skip_relocation, ventura:       "67db36aab975ff46dd5d491ae099b6ded6ff60978e926218e4ddbef1b5695a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe5c05921af0465071703f6d305f291b3baff7feb2855924a84ff0ebe01ee265"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "_carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
