class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.165.0",
      revision: "d08b7679754b9060692206e2eb82ee5e2395b1b3"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86a50c8daf92822e77ce789805e6dab298a38a5f1b86c62cfa0be3920879f4d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "3800a20c1efcce26480d6f2d522040997eb91e0f4c44569a1e69329dec98c2f1"
    sha256 cellar: :any_skip_relocation, catalina:      "8d28710250c3178710934f8047f4f2c306d8355ee4c9fb9895b394daad6da75f"
    sha256 cellar: :any_skip_relocation, mojave:        "55d030a23bebdab1e9dd844eb17b73df5dc539b632845dde6b990d0dd496ee9a"
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
