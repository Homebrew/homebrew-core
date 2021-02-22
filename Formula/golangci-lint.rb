class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.37.1",
      revision: "b39dbcd694baddce38eff2cb2aa86d4e4cf06753"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "29875d77d7cbebd567375b9a14555f46c2a5165711ddb06a81bbe0423d4cba31"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0c36667e70c311f30d021f9b1c0af42961efa16dc4d4736dd6be96f897d60f2"
    sha256 cellar: :any_skip_relocation, catalina:      "24217f232a88d78d6377ab45c4d1e15860906e4d49d1cf11b922c9d8a3096dce"
    sha256 cellar: :any_skip_relocation, mojave:        "afb4f5546c4062dedb3ff2a346a4d741b7123c8cf71559b7954a7d9e76d2867f"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{Time.now.utc.rfc3339}
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/golangci-lint"

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
