class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.52.0",
        revision: "a12be2d59a0e2d99e1c64efabc55d737f352fc7d"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77cff135308e04e538e5cd3ff5db98f725dbfb236413a86599573f2c29783160"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "372535795f30e9ce1a2c4e193c94bf08090b5d676d0e4203f3ec3ce94c93148f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2ca51bac40ac613b6c050fc7543234e40903bd243248beb4c9cabd21ce9bcbd"
    sha256 cellar: :any_skip_relocation, ventura:        "23af139a68309008a0bbd7105e06670d6157152801415a4037e7a5f122c1c8d3"
    sha256 cellar: :any_skip_relocation, monterey:       "60fec1e5f725762c08ff98f02befd9443877e891fc3675a9dff6edd391adfc57"
    sha256 cellar: :any_skip_relocation, big_sur:        "91c88f3fc680a795314482755f8f32916b4937c001db7fa4870b9a3d79060458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eab5b32e313c73c542572cad1f0cd061f9b16d9e2528a3e8127f1125fd5f8ff"
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
