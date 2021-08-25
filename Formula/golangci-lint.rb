class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.42.0",
      revision: "c6142e38dd1e993ee5547886d1e129fdf1ff6490"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b821d10ce40aa92927daa2774bcad2c832b57e21d4ccb41a742526157301a9d"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe608365f6c4b8e82fb807129e78bd099ce076baf54d0ab01dbd7e800bc77999"
    sha256 cellar: :any_skip_relocation, catalina:      "1f46a78a68b21ad7dc3f65d06635bf29b135a01910c1f8f754801f63babd534a"
    sha256 cellar: :any_skip_relocation, mojave:        "c2b0ee0542931311a66fd820344d3196ee61d7f518a500cb9809d7b38fabc046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0851e11ff1033346cfe649c70789c9f7d74ceac793f7a90227efdb6b1b7002d6"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.rfc3339}
    ].join(" ")

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
