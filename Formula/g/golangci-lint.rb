class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.15.0",
      revision: "25c5369a93aacb8cccea0d46e1569ca4a194564d"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ec69931c249c758e5c5dc01e240d161ae3a69bffab90fd32be9640b14bde8ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "307c70daa7188049fa69662b254540e08f52f0b63eb7f63a33612598d7ab5b86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4730cfe51fcf4973575a38c81f344a3df206f5bfeff4a46958d5af7850a9d02d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "daffb2bfac39f4e691c0bfbbfb74b3558573dfe5e3ec7dddbd76a7ca510d7e63"
    sha256 cellar: :any,                 x86_64_linux:      "eae202dc3e2e457e622982637d01ec5dc9ab457ccab27862b903dacfb32059f3"
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
