class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.63.4",
        revision: "c1149695535fda62f6b574bc55dfbc333693647e"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f801972eabdf0c0a70cb4b0bf5378cd88ef907d4830976fd29a1f45da552baa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "349f2f14928ce64e6d43e84c036dbfe4c5bc6d15b7e109851251d1d2059a6943"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5f35688e0aac5af460b25050fa4f3eb7aff564425b0ce20455192a3e9187198"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9d13988a5dbb44b57813567b8d695400eb2ff82e74be003a7544dd6ff9dfd8e"
    sha256 cellar: :any_skip_relocation, ventura:       "7d3b7f3940d85094c2974b22c2c7b017aa7112276342da60e7e6ca2c7c73c067"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b481a71083b84be79173fbc6479ff35117f43120299c0bc9ef6ae892ba2e9ef2"
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
