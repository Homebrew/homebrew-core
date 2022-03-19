class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.45.0",
      revision: "1f4c1ed9f9fad6f04796748cd1e6641dbdee2126"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7e83f86543b4865b7fe81bfd4e2b06252f478ed9150b1cef1f88c63c1c94d1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b770d0ec91db5cfa680ef5afc6516f31c1db8cfb4c028b4bf72d1760961fe26"
    sha256 cellar: :any_skip_relocation, monterey:       "d00c3d26573866885d8c29b99279f2994d9b54c38b52944535bab1b4fa39e8e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "39896d8e432bfc7ed6f7b2f7b02a77636182915798c64097beafc1f13b039b69"
    sha256 cellar: :any_skip_relocation, catalina:       "34b785059ce147b41c298e5c61eae5803881545b9f1543ceb8e7ea3b533620fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa7b8791d8a7381789d606aa23d9ed75a7ca8fe81abc41f7fcd9058f2d842c4"
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
