class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.54.1",
        revision: "a9378d9bb87e3d5952a7586d1008c6fac3ebd764"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb1e622a8570bc87cad5f24200f9df58b21c6ec988d10ebdec1d057ea6d40b97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7939c4f0e3baf46d55dfcd0cfcd44230efb7c0bcfd565e6ea79a95e80f0e4337"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08ec07bdc555d155ad707db1407b0537347174763514e46cf32204137f3ce02b"
    sha256 cellar: :any_skip_relocation, ventura:        "74bacc47ae541da1caa138c83d078842e49f0d347a97e91a7dfc167a8cf6f427"
    sha256 cellar: :any_skip_relocation, monterey:       "4d68a761fa7262b6790e1688aaa35da1dbbf8dedb49782b93ba82501e9a32ff1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0736337bf948edf1d1d3059a95bad1cd92d22b6de287146790a5d6aa0469d87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f15abc4e5b65bdba530ed80d6282612d8491f5ab3dde47b5c32cc4fa757aacb6"
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
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

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
        clear(nums)
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
