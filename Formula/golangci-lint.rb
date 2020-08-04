class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci.com"
  url "https://github.com/golangci/golangci-lint.git",
    tag:      "v1.30.0",
    revision: "45b90f6c7f59a66b95512a813ad341b1b83190da"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "885cb4625e5badbcb4c1b20cad088d0cfc3b4fc8e81306a8cfa383ae0399cbd1" => :catalina
    sha256 "51b949c65029ab93f47e41eca357c71d17178177c1dfdf05c7c56a1c1b028eb6" => :mojave
    sha256 "9af92b2b7cadb94868d4e99f2a53d30633c238d602e33ce8fcd625af7b7dd802" => :high_sierra
  end

  depends_on "go"

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short=7", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{commit}
      -X main.date=#{Time.now.utc.rfc3339}
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/golangci-lint"

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/golangci-lint", "completion", "bash")
    (bash_completion/"golangci-lint").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/golangci-lint", "completion", "zsh")
    (zsh_completion/"golangci-lint").write output
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
