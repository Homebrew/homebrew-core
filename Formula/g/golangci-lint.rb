class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.58.1",
        revision: "dc2815312726b4f374f5c69a1c183a85990917a7"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd4af9fdf3bf0543278ae90cf390fc4650a3b973d5a49613feb1a014d1dc1e82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4028dae67a60c4342e3e0cc35b621834b030fba3c2c0467992c6cc98e5b7fbdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "497e9bc54aa77831edaf804e8d4103617a627536ceacfa577860acf5ce11a7bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b29c4ad6e8eeea4ca0b9398ddf184161c4146a0adfe2f24ccbaa2062b4728bf"
    sha256 cellar: :any_skip_relocation, ventura:        "a5cd3d82b689831000c9208235e328829997e57858578a1e968ad206b2e4e913"
    sha256 cellar: :any_skip_relocation, monterey:       "63dccd9cdfd4f16d1f5134552a1d478ec8e33c4f304506d5f595f99e02e05e81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0430f95deb0c873022cce0695e7adcd3d643b3e64374a5967a0e126d15d0398d"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/golangci-lint"

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
        clear(nums)
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
