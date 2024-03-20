class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.57.1",
        revision: "cd890db217def69d68cf1862504bb735c0333879"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb9692e6edb7c58d8ca82506cb07230332318d3e43e698dd8de096fd59cef877"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a95a6cfedb27ba28bab6c949edfe3a50c59b797a938f3581f8099d6f0ca422d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e13cfe3ed0f44727258c73f7029bcb0957664753a68ee612ea7807ca0a4b9ee8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f467f383bb8ebb6202fe249437490cbd5df4dcaf53099767e18323174c4d2859"
    sha256 cellar: :any_skip_relocation, ventura:        "bcbd81a73aeb0e586d91489e39e14c8a56534d708aacd5610b133a984f5fff43"
    sha256 cellar: :any_skip_relocation, monterey:       "72d111d179fac7c4bc177c9b820931aebac22f2dcbfc1d2b929475feb42aec08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9052642c4852ca507cb4f0d9d95a218181d1b88eb06d5fa26b804d1654d9dcb0"
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
