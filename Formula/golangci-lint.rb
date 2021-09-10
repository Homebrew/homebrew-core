class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.42.1",
      revision: "54f4301ddfc884a7eac5b6ebf68868d6078279d3"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e7f13fd8b6e7eb315a66d810ee22d53e5337a40a4855f0befe3a7cb1fc511c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "bcbdd5583eeacfd97dde10cd5db41dff4a473f14ebf53d0cb7aa99ae9a241dbc"
    sha256 cellar: :any_skip_relocation, catalina:      "218b2b3110ab2a1fe46b7eae2f8ebab0c320f92b44b3b3b00796e8bd9ce01256"
    sha256 cellar: :any_skip_relocation, mojave:        "eb9c9bac43be153ec8a69329409fc0786744a8c8992fa93403797a4aa663f150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b45d6e936c53b98f7e2420b2726bd8dc5ffa2d73bb3dbc2af6b7a2361066a1"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.rfc3339}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/golangci-lint"

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "bash")
    (bash_completion/"golangci-lint").write output

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "zsh")
    (zsh_completion/"_golangci-lint").write output

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "fish")
    (fish_completion/"golangci-lint.fish").write output
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match "golangci-lint has version #{version} built from", str_version

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
      --enable=deadcode
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: `add` is unused (deadcode)"
    assert_match expected_message, ok_test
  end
end
