class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.159.0",
      revision: "c1f9be42e43221793c76ae2b919c3283c0ab6e29"
  license "MIT"
  revision 1
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e64a434aa3eb4249580fe4a545f9697ffe5e5ae8f543ac98093c43f5719a707d"
    sha256 cellar: :any_skip_relocation, big_sur:       "2add03392c41eada288eb39e4d7d9a6d4d8126d244213580593d03a1e419462b"
    sha256 cellar: :any_skip_relocation, catalina:      "9f39bea9793a724f10a93537793d0c0154c6eb20ebc712111394143759b81310"
    sha256 cellar: :any_skip_relocation, mojave:        "8d59f2b0b349de1700b1985b994d688e77c179b77e761f61e3825415f1360616"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew",
             *std_go_args

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "bash")
    (bash_completion/"goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "zsh")
    (zsh_completion/"_goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "fish")
    (fish_completion/"goreleaser.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
