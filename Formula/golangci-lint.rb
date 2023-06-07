class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.53.2",
        revision: "59a7aaf713b326f0b67af27efd90bd93f8513e9b"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c54068fcea1a555531333a835bddf2a58033cd63689bbcbea73176c660e4d4c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6114f22995787abb15b334ce569e29287d6347b810f18f6789e1baa53c6d5222"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6e8fd24a1bcb9f5c802f9e35e6d8de935989860f460f7c69d92893c6caaa9ee"
    sha256 cellar: :any_skip_relocation, ventura:        "8d328cc8e4ff25e54e4f7087e96abb9af61cc63c457d0cfde788f6726e5f7beb"
    sha256 cellar: :any_skip_relocation, monterey:       "0e07b7c6a6c830c2f2ef1ed1206b7e4d5ed854d21c0378b6f3f664edb03d087a"
    sha256 cellar: :any_skip_relocation, big_sur:        "059e308842b8e9e29a7c84aa838e2476baa008192d0bcacb5355d153e1fa0e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0e141819e9d394797f6b5cf1c28bf5a333ea5aae7ed902225e2d9e7afa80f06"
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
