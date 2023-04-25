class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.52.2",
        revision: "da04413a8a1eefb8c10161c9f2b558138d01815c"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c57f2d3d374ded1f20948d48530405e22d4c1541a995cb425912527e52e3c94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c1f41265b1d3f59edef5c59cda6fe6cf898b3e9eeee62087f248689683bce07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b20e92371ec06e39b6bb5342350f1789384f1a58b502319316d7a29acf8c257d"
    sha256 cellar: :any_skip_relocation, ventura:        "14a7188d0af5db1fcabea38fe69a300d3c70451d62bb5c37db78d09c685d8822"
    sha256 cellar: :any_skip_relocation, monterey:       "a97e08d8aedd70cd2be1d05a15e910354a356105eed5c90f67a50434459390f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b87eb8bd2ae2daea8cb51d02a0b1fa665a7033846e006ec60be5363b176deb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54a47d5b9f34113b26f74887d147f920833cab6ed46d99085b2a8965a9f888a5"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

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
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end
