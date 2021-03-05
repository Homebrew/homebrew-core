class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.159.0",
      revision: "c1f9be42e43221793c76ae2b919c3283c0ab6e29"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "266f90115bdc6529e6d292109dc9da563f244c6f3af9752b3695c7a28709b453"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ed58795187845e740dfa987fc918f411defe02a25286e1aa2b717afe5ccd28b"
    sha256 cellar: :any_skip_relocation, catalina:      "0a986999d72e8a2667e59e5c90a9a20624651ff850cc592684ef90b07e62663d"
    sha256 cellar: :any_skip_relocation, mojave:        "347cefc456ef6fb34f00a67ee59f78b23ba97595740ec8c4c449bdb811b65bfe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
