class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.13.1",
      revision: "6d2288e072e6f9c9bca28180cae9ce58a049c912"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "218856f80d4fcfbe71f0cab3539fdbbecfb440429e1acc61fe1d6e5b42e9da97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b7e1a501cfc026c2074ffc06359e7fdff569b9d0c328d590f44d41174df4eaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "250ed65473cb4ca34a8dc9e3efef6f5b8dbc665aefdc69c3fe4b83f0fc246ca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "58baf41b6f30f6ab8b1a536ccd4c2c586fe552d20e27e9d601443baa8bfc7790"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8127d666d92d8fbbfa5865a28d1b06fb30a6dd51745a531db6b9580f8348b600"
    sha256 cellar: :any,                 x86_64_linux:  "0c25f5d5f47d4f1118e9c4a5d2a6d95281ed717070ada8337cdc85a17486e8fd"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", shell_parameter_format: :cobra)
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
      --default=none
      --issues-exit-code=0
      --output.text.print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end
