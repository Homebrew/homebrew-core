class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.3.1",
      revision: "5256574b81bcedfbcae9099f745f6aee9335da10"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed96207a07393cd8a5f0aac4584030a5dfb7ce9cdce206996b79b11f2268ad12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ab155a57e8c3cec710af2e63680bdb9eeaf4d61482b0918847145b6e02b2238"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a10e4248a2502a6c18f248101c67c679874fb9708a35644bab8c505d03591e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "298f613bfc58b600edcb32895e15903bb5a98718a3c8268f655da3c912f8e928"
    sha256 cellar: :any_skip_relocation, ventura:       "0e779f1b7630fef696484d2ddbab00b062e3da367229cf4d279429c22ae1eb51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8321c0dfe8b3cc7ee840234756bf366c697ea60e23f3cb107e0fe4136114016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a9fe92e527836d4215f5347decfe107d29a892ef238e2e87745f6861fa8bb6"
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
