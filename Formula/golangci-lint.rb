class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.43.0",
      revision: "861262b71f42542304a28afe0b396e788e6e4638"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a935b9b430bc899543fe6dd374c7e5624af57fda3e49098c61f9882b62eb641b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c090e8d091cb302aea16871dfa409256a9e0d27c58040c2de9e91940a531495b"
    sha256 cellar: :any_skip_relocation, monterey:       "6a980f7ea6b0e0b8f975e23851971d53608e652d82777d02b49a6835642ea0c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1ba5745eecd393c4cc48b67beef04be690ff05e12b47a6973d5342452c992d3"
    sha256 cellar: :any_skip_relocation, catalina:       "e0209be1eb5db379cec6e45658fc3f0a30211c025d99ee50bfa41f5a165522a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad31ae03a4266eaf19e60777d93bf34f8e38728c2a681c6cea78305acfc093fb"
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
