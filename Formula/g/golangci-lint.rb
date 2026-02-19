class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.10.1",
      revision: "5d1e709b7be35cb2025444e19de266b056b7b7ee"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa263b39e683bf4fc4810d2a5815548c67d85a7f73dd5234cf91a3a03211c305"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aad0cd523e34616dd185846c162f31251ecace6ff44166a021ed7b83d3dcac1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddc6e41a8475dfb0a42854731203ba808e712243d94c1a5cc6a57cab19de6ead"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4fde92c3a58fec827d14667c4419aa9f805301c7b75f230e4132deebb7fbc2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ef6ad11e16510731fdd5927c6a88e57ed7e8cea5a59babfdb92ceb1916b7602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f81782c5e92e65d9e61a7429facd6372d6fdf244fa8acbc5cc642221c46ae9c"
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
