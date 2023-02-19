class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.51.2",
        revision: "3e8facb4949586ba9e5dccdd2f9f0fe727a5e335"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd1b9ac6c17255193a796f2659fba6f534ffc5c6dcef5d2ec24de13eac055c7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c93cbdb369822106adf0cb27ab37e7d7847690cd9348bb8e8fa22362980e341e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6db87b8b8a29117b8672049351dd35dda413ebd0118130388f25480dde5b04a7"
    sha256 cellar: :any_skip_relocation, ventura:        "42741324becabab0820b612398cc31d7990d8c5f094ef524a8a68dc98f083f6e"
    sha256 cellar: :any_skip_relocation, monterey:       "01bfe848dece26765d8eff31b46775e920af753504b98250d18cd57c87a406d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "22112900b33fab6ccd237a7c80261b35318955e256a3ea3db140c492082a3f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "257285ac58cb5ff99731e503640048ad137d22d28716870ef70423cb177d6e9f"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
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
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end
