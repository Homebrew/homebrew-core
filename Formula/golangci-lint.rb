class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
    tag:      "v1.32.2",
    revision: "52d26a3b727ac647f3164242b30f1501ac359e20"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "1dbeccec9a172e92925b76a1a2bcb5de81f9e7a496833d6a29b15581828a73a1" => :big_sur
    sha256 "e0a5ccfe0ba438dcf076a2e7a092849b303b3d51de72a791b4164f673afdd9fb" => :catalina
    sha256 "7dedcbc02c48df80cd6ca972e87ae981c760b2e2d21ec6b1464768c658ed4491" => :mojave
    sha256 "89ccf5786b3dd2c420042c875bc089a2335f40fb29c9f08d56e385e07eb6114a" => :high_sierra
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
