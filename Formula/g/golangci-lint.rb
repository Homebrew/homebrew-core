class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.4.0",
      revision: "43d03392d7dc3746fa776dbddd66dfcccff70651"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdda61a5fe882a0d615a661d59d0c5f2fdebcdfdfcbc3a4125092a6733e0ede5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a44f8a9047e263d3197d35ccd477f08051cc1d8bed0b5b49bef25a19b3543749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c29ebbf1ea267d4ff35b2203486d97414c55d1922a8e7f8d60eb9311c71b3ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdc8f9fbb0be770b4d28352f64b85c79a132cbd6963c5f2c86640a95a2231ecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1795d8a102d3e13fbbe6e9619707d3f43a5a12bb205a289106f22b6709461b4"
    sha256 cellar: :any_skip_relocation, ventura:       "4407e95da139cdd9e7d8800777fd9199f6dcf85eca90e89f4ea5f545244710fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f62de21817026c9ce3284e42cc394364e71b7c024f0532e2efa22e0bca563a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a551fe382ca217fbbe71a826b90500a78c070e687b0db8352dda52a369827444"
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
