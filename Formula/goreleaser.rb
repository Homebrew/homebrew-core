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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1277794d727dcb1b58959f55f49fe819555cd02a08f5f9e486f422fe5bfac66"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ce69364d2cebafb45e937817282fa37ba01e00970659ef76789b1a5b72d5ff0"
    sha256 cellar: :any_skip_relocation, catalina:      "edb6425e43a2acb5b624847f22e7bc592c8f88ab4609c650d7044e708df827b0"
    sha256 cellar: :any_skip_relocation, mojave:        "5e1694cb19936a9e4b5d5b49a6e42e0052ea7542f82434c57a3b2115376fd7f7"
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
