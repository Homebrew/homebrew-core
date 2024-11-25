class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.62.2",
        revision: "89476e7a1eaa0a8a06c17343af960a5fd9e7edb7"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "527910998718977ae57d509c68990544cbd39a6b90e4d6a5c06feec4e0c41cd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "512b71eefd4b182eaee3509c68129c65bb94133bcb9796a7f17d381e40ff2c96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbaed503c0d47e4472de75e307d2dbe245fcc205a491a746645230e0796bee14"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2525d810dfd8ca22a0904ff3215500d20399fdae5903b8172c7465241f6d76a"
    sha256 cellar: :any_skip_relocation, ventura:       "744cb78133a78e5d41f8d456bfdc4704dcdcc9cdebbf961b6a0d806c7763135a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc5faa028fcf877a3829170bbced07015e69f94557e902f0830ca3cc8e0474aa"
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
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    GO

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
