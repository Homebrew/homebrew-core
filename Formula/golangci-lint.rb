class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.50.0",
      revision: "704109c6d8dda9a71572de4a1d9f83bcc786ce3d"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58109eadb566e6daa75e76cc9d72e5630895f14c2ac09e0a4c51176aaaf34ca9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b129ddda5876f5f145a3054d595fd25500ee7580936f122b320401ab3de3291"
    sha256 cellar: :any_skip_relocation, monterey:       "e539898d23839ec079c583095dd270edb1e8f224fcc539b6f74aa13b88f9bfb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e58560df599672366fd7be67f72e1447d38a3295c44d51df1a70ab9dbdb0c00"
    sha256 cellar: :any_skip_relocation, catalina:       "6d0ec5cf89c854855182a3e64564c108dbd026ca8122cfd9de3a03cd98811e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d99ce27a0b79c8aa23d8b194daad99d42350376b51220ae3ee6a34a738cc553e"
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

    generate_completions_from_executable(bin/"golangci-lint", "completion")
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
