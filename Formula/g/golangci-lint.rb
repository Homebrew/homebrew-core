class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.12.2",
      revision: "c0d3ddc9cf3faa61a4e378e879ece580256d76e5"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "622cdd2a0000b713349506bfff7e8e5037d37eb767937774937a1f752dfdd672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ecadb7c7fcda597680ecd2ff273cbedc45151a278d6584f213b9525782d31e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dba3d0357102b5355b22a3a91cac4955ce29b87839b8c969fc0a7272c2b84a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "68cd92af7449aa9371cf65ef15619be50e82f64a0b3632f7675520553443b2bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f3c86b565abb5ee30a8dc3c82c0f989f5d5734be9e957f572a77c3f6a5a6c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc57f85ccd74cde393a3edfd0a246eb208242b02a28d491a3da1a6f793d2d465"
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
