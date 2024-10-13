class Feishu2md < Formula
  desc "Convert feishu/larksuite documents to markdown"
  homepage "https://github.com/Wsine/feishu2md"
  url "https://github.com/Wsine/feishu2md/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "a02bead184c0f9d9c6a64dd5a21b994ff8a86eecd940f6e53ad27e048177003b"
  license "MIT"
  head "https://github.com/Wsine/feishu2md.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "770eec2c17386647a3935e04c6b2227f44b1af33011f526edfeb35566fa78c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f121364f539161ad3df2d4d8812b712bdcd6b4b478f26bf31fcd7114935826e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f121364f539161ad3df2d4d8812b712bdcd6b4b478f26bf31fcd7114935826e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f121364f539161ad3df2d4d8812b712bdcd6b4b478f26bf31fcd7114935826e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e088621d7b83eee24a03be91b3fbec9186cb1e594f7508aef94bdc86e2fd5da7"
    sha256 cellar: :any_skip_relocation, ventura:        "e088621d7b83eee24a03be91b3fbec9186cb1e594f7508aef94bdc86e2fd5da7"
    sha256 cellar: :any_skip_relocation, monterey:       "e088621d7b83eee24a03be91b3fbec9186cb1e594f7508aef94bdc86e2fd5da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39114b4d1ef448d8b524e6643235aadc1e57d68443888cef8b7117547ecda4bc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    output = shell_output("#{bin}/feishu2md config --appId testAppId --appSecret testSecret")
    assert_match "testAppId", output

    assert_match version.to_s, shell_output("#{bin}/feishu2md --version")
  end
end
