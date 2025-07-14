class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.2.2",
      revision: "e9d425110dcd46293652c5981b0a479d091d9f88"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8790c194c7aee7724bf77318ba9a48b8ef7f200b8e8fa2ad4d5c48c452230d97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3158e41ebdb042c28b0ff51876d568fc5bb10510e79c11028bef5101f93a05b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7be2d10713e32d3093d6bb2ae07fbd30409cebc363374e2ee5084630cb0c2c5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cf8777a678f1e5b9b8bbf8a3eedea83964085f55deda35fb2d1374bf3384a8a"
    sha256 cellar: :any_skip_relocation, ventura:       "3ab2c49c2e99308847432b4195c3ae3ad25bea6427caf34b7fee3f4b09dbe8cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "480e5679aaa9a1aa64ccdc4ec4237cdaa3f3165eeebb488d60964d695a93181e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea8b6c7e0e6466081d260683fd8c220fc4ecbac50c0d37c2a8315fcdcdc465ce"
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
