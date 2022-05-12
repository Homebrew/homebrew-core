class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.46.1",
      revision: "044f0a170269dc3d108d65cb520b34232bedde4a"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31c47c0070852bf2c29384d19fc462097790457fa1b114a8a990645f8e2e9cf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27b983e5fe6dd1a179a0ca4aa09c5a2346300f8204e872915063cc38255174c7"
    sha256 cellar: :any_skip_relocation, monterey:       "d215dbd8a3dcb7b4a90b7139633dc43a4c3791f88d613987f58bd7a728c8e37f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0867d4fca9857aa1dbabc3c80bb795c4e26844c5a7ff5f50fa03fef986c70a25"
    sha256 cellar: :any_skip_relocation, catalina:       "bd067c45877db9b34a613a36e785d4a1cf8c5126946d2fa8e6095cb5320d65f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c13480de8f9d40310b2e664f66606e0dc4290b881ad04cbe47a7d2fee285b8c8"
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
