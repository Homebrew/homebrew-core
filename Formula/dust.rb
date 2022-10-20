class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.8.3.tar.gz"
  sha256 "1e07203546274276503a4510adcf5dc6eacd5d1e20604fcd55a353b3b63c1213"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47bd509813fa238a1a0f9a4b68eb26564b6b44d3d0bb867d2d92c0b0df2a299f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "408cbc4f8e8fbefee0a34b5490bebbca70cb8113e7624cc7140fbcd711d930c4"
    sha256 cellar: :any_skip_relocation, monterey:       "5b867d86d19c6d8fa0aafd251e81905db27ca2a9a11b4cf452a1fa706ba694e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f62478725e3245bce809cb5d5574891b1331dfecbbed4e7416dbc099aed306e1"
    sha256 cellar: :any_skip_relocation, catalina:       "572c81b55a1647f43b83305e405631f2b65d3e48ebf28c772ac1ce0dfd7c4e89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ac83b444476e7f50379f62523e8afb76bc9bd425cc171652fc0071c158c3f01"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
