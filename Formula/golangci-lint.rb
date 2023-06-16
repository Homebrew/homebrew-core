class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.53.3",
        revision: "2dcd82f331c9e834f283075b23ef289435be9354"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1342963702b51e520e2ac0b020ca65cd071d00bfc5f9cd62c05fd4182cce2fd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23beb7dadd3c403d4923be0a35fd1e9df23ab2e6b70aa5ad2efaa0dfe5484e7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9bbb46021b15f65ef5fbcb8a41c2c4ab11c4d998ba49d643a548364e11a4281"
    sha256 cellar: :any_skip_relocation, ventura:        "629751098802fc6265fad2e02be40863e429a23ff19741811b0c5e71c6f2fef4"
    sha256 cellar: :any_skip_relocation, monterey:       "f11838db5c8fc6db664f5dbea7fa64d1dc8f152d806164d74ca46bcfbbc7e70c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d04d7f3642aeeefdfea2cab4ae97e066b418d3f34f36b587e72b477b791c5057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30801d8bb730a825865f70e241546a1183aebf32bb082545f866ce75dca62a9e"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/golangci-lint"

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
