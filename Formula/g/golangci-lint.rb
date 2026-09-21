class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.13.2",
      revision: "27774aaf853a4fd21f1dd5e69439459dc1b26e68"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9722379899be2251c7ff39658af987a3492b7c5dc50bd44dc7339d16f0e67cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d6d8268249a9eefaea123dbe269464b19cf834743bdb495370b4e206f001efe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52448d09f496c1534ffc1faa358a5b214eee54336511ab2b16ea6abc93cb9c59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "c805cc8b3709c3696966b332baee7b67e0a4d9ff53aeca07da33e243442526c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fcce0accab58567df66980bb7d52b2d22e5e6cc382c81fe9ccf9e847ce6e86d7"
    sha256 cellar: :any,                 x86_64_linux:      "0373ceacafdae033b71c2c6fc18a31a59872b34d87871e07785416db649d52f5"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", shell_parameter_format: :cobra)
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    GO

    args = %w[
      --color=never
      --default=none
      --issues-exit-code=0
      --output.text.print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end
