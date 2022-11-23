class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "dbbca1194990203049e6e0c95b2e8242a61e2be1d37261ae9168f0c02a309935"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "398a5eae79c1e5b8df0549f56535f0646bbb9a5c9007550317637d56d251c6ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4606dbfc40b5901b6b45acd63d0adc0b7e8fe0c2002dde76a36d0169e451ad32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c59cff01755ec0fc99f5cc671d2ca233cc32f5b000457bb0f11a289105db48e"
    sha256 cellar: :any_skip_relocation, ventura:        "aab8d1bf43a0fe2c222d139811fb683528f962af410fd1d1d806df5302a15ae9"
    sha256 cellar: :any_skip_relocation, monterey:       "8326879f942c76f7f61e4345c22166ede204f75c02a36b7b9b7e4b9a7b037f57"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d2967360552c7e9a4c940fabc91aa826c3fe7b0407aca2760df124820dd030c"
    sha256 cellar: :any_skip_relocation, catalina:       "9fe5f48a0c894144603e6fbd94cb5afcf2f417c0662f0f899ef4a9d6a14de323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "466a81967fd90d354c53ea7e3299fd0714bc5ea896ebef6f35e8ec0d84fe2154"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system "#{bin}/git-workspace", "add", "github", "foo"
    assert_match "provider = \"github\"", File.read("workspace.toml")
    output = shell_output("#{bin}/git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github user\/org foo", output
  end
end
