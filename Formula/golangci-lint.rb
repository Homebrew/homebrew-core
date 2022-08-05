class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.48.0",
      revision: "2d8fea819e651d384cf47784a5fb9c789cf5bd59"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c20056de7a7944fd0a08e0ee191344e525205daec4c4097c434ae3f93304142"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7777b20eb0113b9ce3b9003ac9383ff9ab4eba2954b8ffac15e258ac87767019"
    sha256 cellar: :any_skip_relocation, monterey:       "911117bbbbf6ddd76604015b1032b5983b3bd805fd3768f654e31c70642ecc0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "34b75e9fdfce38aed38953ff7d8b4608298aeec4593986e2e04357986cc1f22c"
    sha256 cellar: :any_skip_relocation, catalina:       "51b03226f59503291a5b093e762a5b625267fe8edd0159d51aa891584a94b873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bf0dfde8ce2949e7c5bd5bf5a50865c9ab852cda4056cc53846927186de59a2"
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
