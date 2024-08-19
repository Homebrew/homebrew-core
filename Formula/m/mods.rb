class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "8c6a79e54fbaf020db2dc59b13bc64711ec38d8c834258368d76f36a7872b0c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3533997a7e5099dcc8860ce67d49198b34df59911c2dea825c5390bcfacee19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb55c72ab11e78e04a10fd89e67f81c2f5f83e86f35365e035c540c16a5db346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81a032681a293c4da253ac51c12c6b257be72e12cc08aafc8402438aad6a0ff6"
    sha256 cellar: :any_skip_relocation, sonoma:         "84901ccc90cb05f39504ed9b9f360ae0e4e0fda40a6c4f38e03121de248d563d"
    sha256 cellar: :any_skip_relocation, ventura:        "92eab47896eccbbe861374383d974841ac28320825a50ca94bb7caa8cb0514ce"
    sha256 cellar: :any_skip_relocation, monterey:       "71faef8d545c72caacbf260d4fe38055547e3693a3a815d7d8e4af83275d51e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2fb38973923ffdb606c7ad423439ecfdf9cbe3a00578155cd8288a210418703"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.CommitSHA=#{tap.user}
      -X main.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin/"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "ERROR  Invalid openai API key", output

    assert_match version.to_s, shell_output(bin/"mods --version")
  end
end
