class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.41.1",
      revision: "a20748098fb3cb4b69f6b6ebb7809e7741122ef8"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e4cbe31f0eb6524e6e3613d3eaf16963d74481c6209cea3f494d360c03341c5"
    sha256 cellar: :any_skip_relocation, big_sur:       "febec79eb5eca7fe1f7163cbf8631d9dca96e850cf2be6c804eb90d24e3e0eaf"
    sha256 cellar: :any_skip_relocation, catalina:      "7ffb50b08181cb637274e66cbb9d6eb6e687ad25e40a785d7b530d27f797159d"
    sha256 cellar: :any_skip_relocation, mojave:        "d84d56b784ee0f6a711be75ce3488848eb8511c02aaa29769680a11b29c09998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5240a3d9d7fa6d77ed98094a376ef686302e02ea280b2957d3b89a19b363867"
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
