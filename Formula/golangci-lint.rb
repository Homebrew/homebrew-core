class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.44.2",
      revision: "d58dbde584c801091e74a00940e11ff18c6c68bd"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f42528341e702bdbb53fb485d836911347b43996e9460cf63d7e304e06400ddc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc31e7befdb1020327d7248c4fbb89864a08d89937c777703bf1e84e87c2f847"
    sha256 cellar: :any_skip_relocation, monterey:       "e5d2cc629c6b97d5c0c8d7622f75022de289db92aadaee378cfee0d1740f26ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "d077bef9f443fa477459f7bd941347af688896746d63bbf380926995c2a100d3"
    sha256 cellar: :any_skip_relocation, catalina:       "0bb937cb57bbf331da747cb1423f4bec62d50070366e1eb6e38b620c004b9461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06e8fffbf1a9bc27738c4541f76f5b58e9b73dc6397da5681875bbe484ceca32"
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
