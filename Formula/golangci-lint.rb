class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.37.0",
      revision: "34e5fc6396d0e225c4040476f41b3143ac8a2f8b"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e8dd1cffdb2b770771f15f6a1a71590dd791996482e24ae59ef1462085fed3d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b7cf01f9e43be11ee31fc4c74221e39de018b7ee6f5b7332ad248d25eed93c7"
    sha256 cellar: :any_skip_relocation, catalina:      "42095b67e5f28551f8fa4ff51adeac28d8f63820a6f489f32427d66574456815"
    sha256 cellar: :any_skip_relocation, mojave:        "35a41358ccac484b40656715550c6b03b328bd1c7463318e2dc54ce64aa7e454"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{Time.now.utc.rfc3339}
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/golangci-lint"

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/golangci-lint", "completion", "bash")
    (bash_completion/"golangci-lint").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/golangci-lint", "completion", "zsh")
    (zsh_completion/"golangci-lint").write output
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
