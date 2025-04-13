class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v2.1.1",
        revision: "93dabf9013aa0cea82ad58e5f90146fc2e62587b"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f76c577eaac25afab0aef17b71d8d7598fcad768985f6b1e215cea7a7b648afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1677c4e622b2894df1a1cc4d508c07368f781e56e98f6ad2ccfcc1461999503"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc2c19e75b432836d836fc781b19cbbc5c0a1a24eb3843428dc938926ac3005b"
    sha256 cellar: :any_skip_relocation, sonoma:        "698a1541453285ca3c10b53e3f4430c894e44f0feba0e808957fbfe734f28eee"
    sha256 cellar: :any_skip_relocation, ventura:       "73c72ef22661e192d29c102304fa2830d13eecad7a1165b200fa523860162702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16ffdff6291fbb0193171d160a16990f278b63046c819a1262fa5b7f38b49961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f9f67a79e176db60f7ec587496527841262c4ce88cfb12ab72b6116a970c18f"
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
