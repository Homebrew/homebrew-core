class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.157.0",
      revision: "0a16e2123647fbbf4e996a737ab1b3f96b4ab63f"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2cc78cdfc8b2987877bf1c150d97515bf5ab8ef3798a0a3cea7604c513953057"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb06acd7ff2c24d46b281277a36227c1716467a7b1ac41bd58200c953a1dc87f"
    sha256 cellar: :any_skip_relocation, catalina:      "902b31a3f0fc27dbc6ea079b2491b39fee40de9abd8b7fc4bf4ee93414eb3963"
    sha256 cellar: :any_skip_relocation, mojave:        "4df38cc661f0221504e672f985f065b68cad461b9c204c522bb8e7137c051f01"
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
