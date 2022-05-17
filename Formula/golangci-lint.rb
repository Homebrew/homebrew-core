class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.46.2",
      revision: "a3336890904cd3efa4f1c7e3f82ce207fe125a6f"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8942cc00f151350b24e9d23b6ee88a2d99827428bb77e031982c17cd392d8d46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b552425a2f9754bd28785e0439f24ff418c033aac74f9382a72f7c80ab508579"
    sha256 cellar: :any_skip_relocation, monterey:       "fecd1843c4fa8a26da5934e046f984c0a398797677aeae6b4cef15bc9fb1ce84"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef6bf5a7444df5a6f4874e564f1c722331dde24c80024ee13865f6b1388dfbd7"
    sha256 cellar: :any_skip_relocation, catalina:       "6b8f08b0d66ed17f67d5d2f2f140feed1bd02dec14ddb3e271ada4604dad3f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a5866b0813232953c353db058497c537f1ea6d35dd1b58dbe812d4750c135ca"
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
