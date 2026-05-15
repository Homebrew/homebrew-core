class Feishu2md < Formula
  desc "Convert feishu/larksuite documents to markdown"
  homepage "https://github.com/Wsine/feishu2md"
  url "https://github.com/Wsine/feishu2md/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "938feb85d798732ed53b1e15b5cb94dc892b79c4eea5bc897750d00f6fcf012f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8a048647d96c65e3452e1a264864e97e3da5ce5349065d54ad04e9ec3e7d38b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4c812d090212b6e7eabb66e2d279ce5efc65c8da48b08f8c7681d5a4c4f8f99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4c812d090212b6e7eabb66e2d279ce5efc65c8da48b08f8c7681d5a4c4f8f99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4c812d090212b6e7eabb66e2d279ce5efc65c8da48b08f8c7681d5a4c4f8f99"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c35747c3979260aecda237aa32d26a43af9c2c1000829cda553b258e69aebd7"
    sha256 cellar: :any_skip_relocation, ventura:       "3c35747c3979260aecda237aa32d26a43af9c2c1000829cda553b258e69aebd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "696c81363f606835062736840a812fa15156df117727e71b3e449af64f53c373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0251b8e957eb435d263ad80c9ea9b0e879959c9bb234bbb9169bbfc4937ef065"
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
