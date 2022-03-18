class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.45.0",
      revision: "1f4c1ed9f9fad6f04796748cd1e6641dbdee2126"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d40f6f96ab015c34d0864e7a7b378ae63594085a725993a0ea037cbed87bf4b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c4ec94207ef51428a1f5166dada3c40f6589f709e1950a0b023e3647419d59f"
    sha256 cellar: :any_skip_relocation, monterey:       "2ed4613779d65c18e57abb2c0f49c70be5c174ca3b73ef8bdf5502b1a8f5ce84"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9c9648ae8ad7f61bd598fd8cbc1d7c0678f68ef025dca036141ea70035e4a95"
    sha256 cellar: :any_skip_relocation, catalina:       "f324b4956312e539a2d2cf8e8019b5086f60717d5f4fc82ce188984e76275c19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be97f50d4811fa804a73d419885b9dbeb6209ef012472005f4f53364909e6111"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.rfc3339}
    ]

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
