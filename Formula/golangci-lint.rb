class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.51.0",
        revision: "6d3f06c5eba95bcde9ebb9e0586a7da50599e3a3"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3d00d4719199fd7c376294e8b5d3cd83ca199abaa0a25d8e87847e174bb2aeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00d0b1523c8d47f0372d85efc22c31ab2e40825e2b36de441d2bf3d4dec9277c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "132c057ec5d0f8a713055849cd4cf2a66d45133e44b60bb3a343b546b6154985"
    sha256 cellar: :any_skip_relocation, ventura:        "c07d3a7b134e10f465acb7728b3eb20c694ab02791cbe7feed64fadeb6875e46"
    sha256 cellar: :any_skip_relocation, monterey:       "e18d7d01fe317aba5bd80b4b9f87474251abcf6b6bc2d1b61d778bd172454184"
    sha256 cellar: :any_skip_relocation, big_sur:        "645c684084e0e420f9a457e54234197625fb422c367c62b9b3de7f805908621f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8645784e9d49f8fc7afbb5f1302e59fa8062a7c95a933ba9d8541abc24d3af30"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.rfc3339}
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
