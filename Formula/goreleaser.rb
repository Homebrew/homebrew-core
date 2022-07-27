class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.10.3",
      revision: "315935aedc9908b078ae525b33ddb42b2fafcc54"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cea8d3ef6558a44e6636310a41fab852a6ca178705eee5c47417a2853f305115"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fde47077d5bdcf1625101b0219dab59ca4cdbcb7e7c610f970fd59df983415b"
    sha256 cellar: :any_skip_relocation, monterey:       "37542f02b46dc779cc34c8e42a6c0c92563c260cf8e228661ffb9a07b66e2526"
    sha256 cellar: :any_skip_relocation, big_sur:        "e45920925805d6fd4801fd0b744c0afb81cdda5c06159e3e4b4c2f96c879b875"
    sha256 cellar: :any_skip_relocation, catalina:       "a8a4a6adc1659c9c4839036bb04ff11e6795ca1d29a3f490eb67579077a192f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d854d222806ba3c1df82c7423614a8bc66ffd8416eafc699f47cc554979a19f2"
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
