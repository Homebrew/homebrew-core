class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.1.6",
      revision: "eabc2638a66daf5bb6c6fb052a32fa3ef7b6600d"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b80012d1179f11a0a79d0ec3fa9155db068ba75d638fce9fbb386c4e605cfbab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcc6b4a7485deddbb1cbed2846b7cc4384dc7977c34706dbc8d7561b795f2254"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7b4c863107265a25e9bf4f68344023038a30c18ac3168dab44941464f040de4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f32dc08095420d13326009a0abdccd6c91bfdeb573c94dc83fddea51a66e17b"
    sha256 cellar: :any_skip_relocation, ventura:       "63994547cab21c5da7206b9df1da16b2df75d78abd44a30db493aff1f5d51b98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7640a45b1e0c68a0096d97b45d60851f1e60be478e681f5b3bac20998ecbc63e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b90ac1736b55e6e911bf760b1bb1d3ca637c4c62aee270f34d3e95783cd7bbb"
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
