class Feishu2md < Formula
  desc "Convert feishu/larksuite documents to markdown"
  homepage "https://github.com/Wsine/feishu2md"
  url "https://github.com/Wsine/feishu2md/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "c5b3cacff5a9f7445d9380f3128f7daf21b230e936f19f5f219c70e17b1d7651"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a3a777e0d91360a427ccb73a2f73c90cc3a78f996111de046cefc78a3b39587"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c028809d6d065185a4158e53a9eccd22240648f86e7fe2889c48d4068960d3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebd479f6a39919de7e1a13a003341532635523f7ab03327cdb06d54e8cd631a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a21aec84039b940d960f5b042d8a788a729191a8f59326070f1aaf5494fc5295"
    sha256 cellar: :any_skip_relocation, ventura:        "21bfa3d183e2f5c316f1fa68f6d4a2f1eea100d33d4dbc0b6704c53be9932aee"
    sha256 cellar: :any_skip_relocation, monterey:       "4943fc98ac35fdc37816128d316aff743d159a7afbfc3f87809057d44cd84fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecf21d8d6fc807d62af66d6ab25e462d5e08649d970e7a2454b1e5610de50e2f"
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
