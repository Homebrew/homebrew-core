class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.5.0",
      revision: "ff63786c30d6c2926f99d677ab2ecf089e9390ad"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "169066b024abdc6fcc0cae955af01c290a89c444bb483fd7bc3747f4261912bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d099ddc37e4e78a7b162ea04956e7dfab3c344878f4d9ada09c50c9b069c18ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81b671cd36a2490640e944d488657170282a6ee4eab0ec06d85ba084d620f425"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ac9412d91f1a0d72bec9e9b0065ee731d84d1c62efb8cd923c52a5bcd2603e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fca739b2a0a19bd8a7e6a6ae2b2ddd2aee8cd63a6fca0fb80d190fda63ea3f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3083d6f13f2a63237af1d41ef33f745f7b7ab91213f313ebaa6d5d2c351c73b"
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
