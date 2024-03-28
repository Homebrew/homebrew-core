class Feishu2md < Formula
  desc "Convert feishu/larksuite documents to markdown"
  homepage "https://github.com/Wsine/feishu2md"
  url "https://github.com/Wsine/feishu2md/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "79fe0bc0839f2560d6191e434f630e073d9f7d0dc2d685463eb6a71bd1095aec"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eeae48c99823ace71e8d9f5cc0bb78d7c95e0dd12606b7db76b49c48d15a2dee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "108760a99cefa61a5c15c413244dbd38d8d7dd77e63321fc13ab3b6a37117609"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3f5b13d4423f6d6886e7b9bb43e61b6117fc3d2b427864e54197265a8c78c0a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d871e181c55232709c68d453d549d55c7b8fec12f2dfe69be723fefe02c8be1"
    sha256 cellar: :any_skip_relocation, ventura:        "66e34b4e23437dc54edf1296da5ab7203c3564f28d44d725b1f2ac16b624e60d"
    sha256 cellar: :any_skip_relocation, monterey:       "a2dabfee16043d3a14574772070d7ac4637d09d5a640ff1e79a3ebb4656dd5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "751f69c4edb4e9619f3f3f99421399c7f031f3a774fafccb7234511cb9488c4a"
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
