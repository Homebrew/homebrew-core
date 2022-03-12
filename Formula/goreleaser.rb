class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.6.3",
      revision: "42258cf4733a9f42b17ad1b47fb7e6e2a10369c0"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d4358a546601c9bb0c5c01d960a170711e7dc4b0c19df1b992bebdbc6c5553b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21cabc39935a0ed835a62d32b90cbe7ccfed4a46cc0b71fce52c37859d8f287e"
    sha256 cellar: :any_skip_relocation, monterey:       "f5335ad794e10f836b18b64ba17ede5ed92670f1ecd4748d4368fe68e919e31c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e536ef28d5842370e7a6892a79dde058d12eeaaba830476b444ede2740d53745"
    sha256 cellar: :any_skip_relocation, catalina:       "ca925a72ef19c792ff12ad48a72e74cf81423623b42a3c88a8f50d4b8a69cb80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa8392ed2b74045819e1fd01fd6f8e31c83a6af06a68425a7b56e28ad4a635bb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

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
