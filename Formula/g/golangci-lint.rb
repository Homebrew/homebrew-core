class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.61.0",
        revision: "a1d6c560de1a193a0c68ffed68cd5928ef39e884"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b1df4e853835bddaaf46608c4ec3b2cd50d926769944b7930e7741065d1be750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aee1f87ed6dc9e6c4d023fa19514fe8c1ba24a6b5faecf32b4d04b3fa79a8d72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e55d5c66470bb69dab207c5c778bf08659b711d979f09512ebdc7b6570ae1d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45cb4c20483cb59e4ce95c039d53c8fcd75d95df621f724b3f4ba5eeda03f854"
    sha256 cellar: :any_skip_relocation, sonoma:         "869d459d39eb618879b583e9507290e195e92daaeac820d08eedf1b7bb8213c0"
    sha256 cellar: :any_skip_relocation, ventura:        "475a66fe6dde49a98010ab5a69fcbacd61dc5e8eb314ff0c98b780e93b599343"
    sha256 cellar: :any_skip_relocation, monterey:       "48b72ee791d7cec422ec38424076efaa72d03804d92d26fff8b2e84981948b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8493e57142a61f483c944bf470fa1a281954ac9c19627b60dd4c9c0f50f050"
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
