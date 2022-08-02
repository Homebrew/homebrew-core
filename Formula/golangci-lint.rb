class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.48.0",
      revision: "2d8fea819e651d384cf47784a5fb9c789cf5bd59"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb851d751db63d9f3ed6a87aead9a2142f872f3a6d1d992279958f0304247936"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99249d7ce31deab7c290322031bfb33c6c3a7da0fc166149e2010e8756769a55"
    sha256 cellar: :any_skip_relocation, monterey:       "993aab46c827146221b28efc920bbb6d6becb83c969375d28d827423deff8264"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3c3ecda34226c40d2032269aadc19e6e06ace2d14d2740b2549cb35a8f5089f"
    sha256 cellar: :any_skip_relocation, catalina:       "84dc168d03931171156db6064aebec2aa7263ff1010fe56cf53dced32ab48c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cbdb939bb01ac6f2102a31e6c367f54a7573fb086d32748c99245caa6d211c6"
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
