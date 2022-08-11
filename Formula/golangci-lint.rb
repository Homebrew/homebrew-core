class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.48.0",
      revision: "2d8fea819e651d384cf47784a5fb9c789cf5bd59"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d640f9b71316d197af6b5c703c8ae25940a149ae886758d13d80b00bb348b53b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d579c3f305a2b21d800044074099a6c760c7f1566e4d48588eed420a4253ea30"
    sha256 cellar: :any_skip_relocation, monterey:       "da66cc5a29f0785cd5cc88cdc1ded6ffdf3ff0647749feb87ab48ec362a0d757"
    sha256 cellar: :any_skip_relocation, big_sur:        "973c24d8ab1e13c9d230904e0304b643ea774a8cb5f57de47f7d87c975ae338c"
    sha256 cellar: :any_skip_relocation, catalina:       "a073bb692801d6cc3db61b5e25e199830831d8befcf2bcc82dde97874976a1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c68324441452b40d8b2603870bd0f49298c5cda31a702164f3ea2b5f39302b9"
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
      --enable=deadcode
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: `add` is unused (deadcode)"
    assert_match expected_message, ok_test
  end
end
