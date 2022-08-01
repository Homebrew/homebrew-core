class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.47.2",
      revision: "61673b34362ae2a8af6cd1d74f69c22b091bf00b"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5915ac8df72bfddbce6f90ebcf5fb9300ba0b16eb71850e8ad4a524bb820bbce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "465506e0e161b17534087b80c3167ed8cccd9e43a5ac5c76df52bfc92fd6838b"
    sha256 cellar: :any_skip_relocation, monterey:       "6bd9f2819ea68fdb94ca258b6016f889c936478cbcaeb1efd131cdeec5b648db"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dbab86180bf70eeed64bda47f118e660f52f9127f7ab84ee05b9696614f83c5"
    sha256 cellar: :any_skip_relocation, catalina:       "dac5304e1fe554d333daeec4c5afd691875978b8677dca9baa3b6fc25283ae0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b337b08d58cce42916469d2152bd3f23262a426912ce7e9cd31de1c4ff20538a"
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
