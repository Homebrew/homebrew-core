class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.52.2",
        revision: "da04413a8a1eefb8c10161c9f2b558138d01815c"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "090419f5184aa0c053e1640e537335650895281923c235521b66cbef7c00dac3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87a9dd2358c2e06aae3e38b29629192de8225f603312d21e10663554e31b5246"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5981d39b715b5a951263b6f6535d599ba126793a337f6e1d341566fab725ba3"
    sha256 cellar: :any_skip_relocation, ventura:        "e5f2cda93e037942f3a5c81e938417906bbf9a9075c8b41cd9f2c5e3b4ced0a2"
    sha256 cellar: :any_skip_relocation, monterey:       "bc5c18a25b3c30b23416eeab0ce8ac90fb8ced3d7bd7de8aeb82e6f48b356f93"
    sha256 cellar: :any_skip_relocation, big_sur:        "35d4bc1a235d321a692a401edc19037e49b5618a698426e2510783f3acb3de2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3dcab535020d191a4b40a0302e2659bcee560a21f1bcaf5f7fbe5f238fa5bec"
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
