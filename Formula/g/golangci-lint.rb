class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.11.3",
      revision: "6008b81b81c690c046ffc3fd5bce896da715d5fd"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf87529924458ad386cdcf0a37ce7712cdbee58a26ca589bdf460848b03c69ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39a78e9f03642cd22139dd96585df6dfc8d049d34a24047b69b706c4aecab291"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d37892c1c11fd9fbd2c7f16ff0e6db2208cf00152628550e739acaeef4f1624"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cd6a38afb938be38243ce39445910a66a0b0ce4a347f55b1d5a1167405ed7a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34177c381b99e6c669b6b8824acbc280e18b465a4324c33a00dcadf56da24cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "752f843298fcf603ed7affb2613b607ea0944e9ad5fead4f41e5af36385f07b3"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
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
