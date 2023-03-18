class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.52.0",
        revision: "a12be2d59a0e2d99e1c64efabc55d737f352fc7d"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f8b23b2b4f2298897d8aac231922f68d77124ef79afc7d01ad871883ea852b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4c1bd8f2a0dd9ca4a08d604551da826de307b702926523da0c3b3a903fabf88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35ad577f49fcf2efdc4dfbaca095bd4552d0bc4b3053f9dd1494418d62f9c51a"
    sha256 cellar: :any_skip_relocation, ventura:        "9fa03814c7ef29cbef4f8a3329afbfa32aa535e66832ecc46b141557bc721278"
    sha256 cellar: :any_skip_relocation, monterey:       "51c1457221ff48c23eaf03ef8815207e66d71a91d22cbdd41d7df6283f65b6f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "808616dadada8031a8a14a115709ab036135ecbe4f7f46e5fd7fe0e66fb6103b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec546290e5b54a8458389999360121401337c7dfc7cc67cc7c19f35e82bb46b"
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
