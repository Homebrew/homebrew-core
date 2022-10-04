class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.50.0",
      revision: "704109c6d8dda9a71572de4a1d9f83bcc786ce3d"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "790eba5d113226ccd2a5fad4ad6d5bf5aafc7a9dda6a32cd08bc032e74b98a9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0239bd2993c5a46f42de9f8bd30bc3700279370e9660e61d4d908a9623cb236"
    sha256 cellar: :any_skip_relocation, monterey:       "013ea67d8c8a6bd7276bd689ed44fb7e0072f2b2e93be6029c2582803dd5fe25"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4c69256964d8d727743870f55c7740361566fb32ed45461c3270b0436cebe53"
    sha256 cellar: :any_skip_relocation, catalina:       "72eb2f241f8a43f9dbffbf282108345a8e1c5f41cb78edda625f9d9e0b40f84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3656e3077a2e9fd6746c1e22c736c5e07b532d2c235829b05d12dac6062fdfe8"
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

    generate_completions_from_executable(bin/"golangci-lint", "completion")
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
