class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.57.2",
        revision: "77a8601aa372eaab3ad2d7fa1dffa71f28005393"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5933aace6220dba4c159b3e93929859e464bbd4bd30e4b1ae1c94053062c8320"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "835312df75054fdfd43aee0a2b746cf077fd473eda4f6fb78cb0035f4a71b1e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41487649d94b71b3abe8a6f6501d5db56ffda4c726a2cf060376421c49a8a0f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "edaec0be4259e813fa85188a613cf90e390e005299a6cec36da084383b1c9e11"
    sha256 cellar: :any_skip_relocation, ventura:        "5dd87e1401371edb4127e7ac8cd5b7ad095029543acd7b756ed2bf50054a3924"
    sha256 cellar: :any_skip_relocation, monterey:       "b3ccf96a04e12c3874c13f3f61b42b09953611819298c93cb85159e8d09971d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ce20a10f8048556ff14ad48eb748888923f79caf3682a0b74f4f72ab06a4062"
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

    generate_completions_from_executable(bin/"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

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
        clear(nums)
        return
      }
    EOS

    args = %w[
      --color=never
      --disable-all
      --issues-exit-code=0
      --print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end
