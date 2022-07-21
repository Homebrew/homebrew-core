class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.47.2",
      revision: "61673b34362ae2a8af6cd1d74f69c22b091bf00b"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c142395daf34735e6c0724cf90cbb7279b9649827c7a0cb644bbe20af66bba3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0b5679de6ed10954a25acda8fecaea0b408181da8fe866cfc13010b207a2aca"
    sha256 cellar: :any_skip_relocation, monterey:       "b5056db9353e8aa921c5af2320c3babc975de83d021ebd531d768bec21f522f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca183f713eb9630d146cd251e8ebea681f546c77cf1d30d4f409b3f16ad5781f"
    sha256 cellar: :any_skip_relocation, catalina:       "ef5faee2494374732767cc6c17c6035a28109ee4340c02558a9307d8e0d49d4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44109c4948bf07ae69833de232ae3550cce6559973193cfc76d3f16daf7f79d9"
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
