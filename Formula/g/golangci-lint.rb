class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.57.0",
        revision: "ddc703dd93e37d9e737df2bb46a6e4cb5c95cb07"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee84569d8958818d349f1469df735516f5bcf9b4279bbde7430e4a484f9d9457"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "543e20f8d07476c39fc47e41cda729a9b2103e509b9143c09a874aca3ebc4565"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f21b69264bf58e42698664264350237937c566b26941668e8728a885b05e50ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e3cb354f462bac80af65280913f2ed563f61dbd3ac0a187eba86867ee45ef70"
    sha256 cellar: :any_skip_relocation, ventura:        "6dba48058120cabfd07fe4bba00efdae82ccaf86ff6278c50340c2a5a84ff3d7"
    sha256 cellar: :any_skip_relocation, monterey:       "769afe51b3cd666f955c71af8e9b7face42a92aae217a03228e87c4c4b0398ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49d8ed9d46181565771ace0e200cc3f0fcdec3696883a5f32cf8dc941be14273"
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
