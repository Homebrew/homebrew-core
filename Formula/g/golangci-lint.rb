class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.60.1",
        revision: "3298c104802d118670a487b330ddd3761f7afe20"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c00403ceb4e39434ac7b16e4f4551436c628d39ebbc59b5519cdf22ab1787967"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c0c66ec4470aa7a2af001cdff1ba36556a215fc90fab6d64bdb74cbb8e05702"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "156208443e5ed497a3afa270b833258f28feb2847abce23c984d3b0a88ae4ff7"
    sha256 cellar: :any_skip_relocation, sonoma:         "782d2c8ae5c888598fe68bd95edb2a2bb28ab323e6639c6254fc4da7b1d0c020"
    sha256 cellar: :any_skip_relocation, ventura:        "06378000d09d3f7e2c86aa32c641940c04a5a2d36cd549c54647de8ab7ebb647"
    sha256 cellar: :any_skip_relocation, monterey:       "8fdbf2af19ff9c5c71c6e24caf425b90c44460cb1c6286513bd3e4003644c909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24b6bd265ba690721e8e107acdfca256b2b3b1b58eedc78aa192294f8cf51a23"
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
