class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.38.0",
      revision: "507703b444d95d8c89961bebeedfb22f61cde67c"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "788a56cdf07d64099f15ae47ca2394323207269c7e5374918a9b9d3d987db649"
    sha256 cellar: :any_skip_relocation, big_sur:       "d704170150cd3b76a02c5d8f7d34df4ff6aa8e417c4a60ab3112640ec7d12b74"
    sha256 cellar: :any_skip_relocation, catalina:      "8238c1c688e526f0b9e9ceeecc0cc2ecfa7809c920c13ac8d2b2a5371cf835d6"
    sha256 cellar: :any_skip_relocation, mojave:        "21c9776755923872d921bdc73158410a52eb4a5f537deda2428d3679be0016ea"
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
