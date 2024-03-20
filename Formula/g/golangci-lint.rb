class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.57.0",
        revision: "ddc703dd93e37d9e737df2bb46a6e4cb5c95cb07"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dcc0bdff4d6feca861b4b6108d55167aefb0482852e5b7efb3650723c8f4049"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fd291d4f3a7101f3a051f9e473b37a9f362bcd9375fe6d2f7c8f7b17e169fc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "499287c7e5a47eca90606494abd1ec0851f895b51bc800dae346b112dc185c75"
    sha256 cellar: :any_skip_relocation, sonoma:         "82484d17149e4fbf37792c15b61e99b165156ca10ad61353d88058b9b061dbb9"
    sha256 cellar: :any_skip_relocation, ventura:        "8047de8cc1563ee825ba8443c37918de84e23e78793e718fae6d9f953400c8bf"
    sha256 cellar: :any_skip_relocation, monterey:       "842c5559ab46fb34111803b7c7a5fc9bbbf20868f27e5173d1f5b12fa34825a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fea34e2b2a3e2748a4798d02a826f9536c908b39969823e0753778c619df87c5"
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
