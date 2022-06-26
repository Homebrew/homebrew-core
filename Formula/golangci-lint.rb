class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.46.2",
      revision: "a3336890904cd3efa4f1c7e3f82ce207fe125a6f"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea0e1168417d037638587997c39961604f5352bea09b6bf126c9f97084176ee7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa8f329176d1ef12ed671861bf73cb2069c5d43438b3a38221f801a626e99357"
    sha256 cellar: :any_skip_relocation, monterey:       "c4b73e64134fe32852f1455759785e7f3391775bcc4ecff5f887de18e1a6fbe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcbdac8340a0a1d4519ef5303896b748c70a2c3cf086315f5b6e53e79020a23a"
    sha256 cellar: :any_skip_relocation, catalina:       "39c2acbab5b65ea37fc9a0dee059aac3fef5c9182ec3d1d600f105932ca598ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "271f4e9d87905e6106a57f277e90ae4048b361ee3c621de55c7d633951043112"
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
