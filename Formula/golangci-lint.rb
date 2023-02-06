class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.51.0",
        revision: "6d3f06c5eba95bcde9ebb9e0586a7da50599e3a3"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa216e5e9becb68cdbbf87154f2cd8feaf581387694eef3ba87d484becbcb89e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b359ff9a987f187e510af083c74e7c555318ab826f22041dfbe28309cd62de52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c0f99518a51b03e6a64ef5bb5867de93cc3c7e5bae5718bd7748c2bc8164aa4"
    sha256 cellar: :any_skip_relocation, ventura:        "39943083073b9ff22c5dbcc6900f3d03615121c43e9c149175be9da20d85c2d0"
    sha256 cellar: :any_skip_relocation, monterey:       "5f589853958c01961c0058b0014ac86227df2593ad8d6ddc97ea5217721d75e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b07ce06c113d0b56983c864ef725d2f72713053fb3a2ebd1335f9c248e77206d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2823b5015eab773ec01ea1b5a06680c57ab3593d06825720d24088f90c984d2"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.strftime("%FT%T#{time.utc? ? 'Z' : '%:z'}")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match "golangci-lint has version #{version} built from", str_version

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
