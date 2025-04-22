class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v2.1.2",
        revision: "00a561d9a79578a2800dece2f04c60ad479a3798"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0efd6f6ed59f2edc0cf1e69da440a00d2cc9a1af9bed26b2fe1a565285153908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "635fc3aefb3309a2b9e4b9beeebbb307615ffd09b0749abc1e42423c7421d21e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2465059d185a913853cbc6d33dcea4f7c0c89e6724c147265376a79b30c40fca"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cda1e3cfefaa45efe9dee023c2ca2671652a2949ee3b2544b80515c9821d4d3"
    sha256 cellar: :any_skip_relocation, ventura:       "29b8e541506327f4082878d22330104c378967f21a7b4defe982bfc4b6ccbd43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e58f529b19a84d1d0279039494b3831a0cca0fe0b45369c5f0002b52f175da84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3af5622af1ae523e7c2b77277ae77fca8feca2117a6efd649978bd0390bcee7"
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
