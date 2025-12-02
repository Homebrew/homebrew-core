class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.6.2",
      revision: "dc16cf43c85d53f03e00a2f7b93a5e03a1435793"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b7645ce02f117edac1b56f5751399aa259e5f8d887226bb5d1909e4de8f01ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7a17644350a0970b68a42196a70f93a2fd2cd03d91e00427810da46c23dc0c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ecfab0d9209eacfe62fdda2a05c788ef62d9849fbc95a2ce169c787231677f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9b8f25ba387bc6baf4dab3bdc40b052efe5bc287a1fb5fe0aa548e3f7f79e94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9426133a3ff1838bff60abbe69fb1a43b0a4db2c9fc2ad25fcb1be0fa2952a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fc40b76d911dc116fde2d4508ed6d7be4c9fa0223c6b8caf00cb636d8841375"
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
