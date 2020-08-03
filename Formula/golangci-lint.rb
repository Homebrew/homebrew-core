class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci.com"
  url "https://github.com/golangci/golangci-lint.git",
    tag:      "v1.30.0",
    revision: "45b90f6c7f59a66b95512a813ad341b1b83190da"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fce5407b3cb659f7d9ad9871c194221e30449384aa436e23611caf9dc2687f98" => :catalina
    sha256 "aef67d3cad00979c270087a554a9f95367e71989418621f900977fcbfdd1f9a4" => :mojave
    sha256 "d18ad41206bdf801ea20c88b0d43d1c06d6487804a9cbec8c97f0acf8997a6a3" => :high_sierra
  end

  depends_on "go"

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short=7", "HEAD").chomp
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{commit}
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
