class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.3.0",
      revision: "364a4bbe30932b8eb1cd88d077efe1c0a9025856"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7c405be63ba184e163290e76ebfb945c706c94847b4e44525cc3154ede4415b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c4dfe99d7c31d31a250fc78813746fe0cef91596c3ad67e56764c95eff4d3e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b2b278ec92146ffb05349d9ef3e4500997eef0de08ea054b79743f29fe0d07da"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c07bdcde5deb0fb2e5935783b1e387de0a14d6d54ca6a11a9bc07e4cd1089bd"
    sha256 cellar: :any_skip_relocation, ventura:       "be9a42bd3b4e4dcb76aa4e3467f2dd28ee83aa21f8b3571a19537441d7adbd8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c10eb7b09f28c0932bbde30502dfe1c40ff9ad6330f9b13afec4b6432d40cd2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3245d7af5a0fa85d86f6b046557e561ca88809354967e38c2929f9fe71d285bf"
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
