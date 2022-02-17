class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.44.1",
      revision: "9a70e9a458267ae6224cea2785da5f66f0687cfa"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b42eb53c7921abbbc6e05d055cfe43c52f4b98065b59ba7ebe6ec8f03d4ca51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a6f3bb4ba129ebe89ebbd569675285cd7426e4f6daf3f4c3044ca9f2acdde2e"
    sha256 cellar: :any_skip_relocation, monterey:       "95d5384656d52a3274b6b107c213930101d857ea54b84aa883ed296d4331055b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7300525291a8452685b37487e4e15adebd9f5545ba7c97068914abeccea47f04"
    sha256 cellar: :any_skip_relocation, catalina:       "7492f258cdba289a32fe72befd57aa308f494cbe63943462a6a62e160dd271cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d25c23a542624e2dc083c5bc768ab31eebcc4a21f84ee35aa624958726a11cc"
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
