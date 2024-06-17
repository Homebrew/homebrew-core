class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https://g.equationzhao.space"
  url "https://github.com/Equationzhao/g/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "05df40665ea8c402c9d76b29269edb721758e9913bc03d173e7e84fa7a0a2ab6"
  license "MIT"
  head "https://github.com/Equationzhao/g.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "939666f4a65a2f890078c817a1d37721fedd1016dd66bf209e9e06d511590c74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5630586971a6d6a7d94cc5aca08c105b8a91b6d3f41e574ccff636928cfcebb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40e2f45d0fe31ebee0891107fc9ca7053d85ee013ff1381d628caed4113d45b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "c781822d38ccbb2589a914fa75cd3dcb5f75a6686f8ac8c297003133ed7a1a79"
    sha256 cellar: :any_skip_relocation, ventura:        "6b8e5619b246493883d39a4d1cdcf7a18953e46b49fac2488e0e2ca6eef35988"
    sha256 cellar: :any_skip_relocation, monterey:       "2058ddd253e9430634d40473cc17b2b8c92f3d3b76369d695495dc6abafa2a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf64ab50554af9669d884264a4f022c2e13b1c353ec587b1f3559bc8ff37e3dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"g", ldflags: "-s -w")

    man1.install buildpath.glob("man/*.1.gz")
    zsh_completion.install "completions/zsh/_g"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/g --no-config --hyperlink=never --color=never --no-icon .")
  end
end
