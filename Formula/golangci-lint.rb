class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.45.2",
      revision: "8bdc4d3f8044b1a20e10a9f519b5f738e8188877"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71a47fb806a5c34a18a52d4471019c0b34d8e1c4a17fe424301360285ab7decd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46cb8d5eaffa0292d787b7a75af5ae154355a2aeee211d6d681559b939885084"
    sha256 cellar: :any_skip_relocation, monterey:       "5acfad66b867a071a756f6f0d45b452e6121c8420a884dfd48165de19c5051e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9871a6b60c92cb69a4cd98cf6f718719336c505f35984b00d545704fe418955b"
    sha256 cellar: :any_skip_relocation, catalina:       "4c86ee9d62cac7fd4b6c7e1f7a2f5fb4ad7832e0e73d93e8caad088a2d8412d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92de2b1e33e96085b7255110ff3a3875c6f40b692d6ed4661be50826dc6202a4"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.rfc3339}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/golangci-lint"

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "bash")
    (bash_completion/"golangci-lint").write output

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "zsh")
    (zsh_completion/"_golangci-lint").write output

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "fish")
    (fish_completion/"golangci-lint.fish").write output
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match "golangci-lint has version #{version} built from", str_version

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output("#{bin}/golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~EOS
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        return
      }
    EOS

    args = %w[
      --color=never
      --disable-all
      --issues-exit-code=0
      --print-issued-lines=false
      --enable=deadcode
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: `add` is unused (deadcode)"
    assert_match expected_message, ok_test
  end
end
