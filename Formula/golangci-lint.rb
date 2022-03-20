class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.45.0",
      revision: "1f4c1ed9f9fad6f04796748cd1e6641dbdee2126"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a0c23a394cb3a0951ad28f895f99f82ca5864b6ab37ae98b346bcdcd027ddc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a99835f44b68425ef272be9b6e25b28da3505ff88852e996305dfa0828daa72"
    sha256 cellar: :any_skip_relocation, monterey:       "39e39dfdbe57dfbd1d37c140e93734b211a014b5e9928842e92326194c103bbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dbbe07f6489859cdc4fe6e9a25ef3160ab916f23501706bd4d83a988f2b6652"
    sha256 cellar: :any_skip_relocation, catalina:       "7d2f08d626607cc19ee6b6b898e353b08a06c1523fdfd4d549d228ec96675820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b78a88905db943c0996f89903b49c6d41a0d1687faf340ee5ed7a69d7acbcde"
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

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "bash")
    (bash_completion/"golangci-lint").write output

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "zsh")
    (zsh_completion/"_golangci-lint").write output

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "fish")
    (fish_completion/"golangci-lint.fish").write output
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
