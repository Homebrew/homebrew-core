class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.54.2",
        revision: "411e0bbbd3096aa0ee2b924160629bdf2bc81d40"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11c955587b8819cf77a9be780aa0f62a64d2648ee43c969c9479d5fd8d4b68cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07edf7a5e23476aefe3335b50cd64f832727cf11cf5b9e2a0dcdc4ea3048cd93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fb53fc61c0cd0ee3767af0a852a2a2427f158963035644d2e779bceceacd6bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c100d0152d236cb58d6b65b48cb39f81998c7f899ae7d2f602f06d2937f44d55"
    sha256 cellar: :any_skip_relocation, sonoma:         "629dfe829fb1d12195b0d83f68b45edb6dd53acd152e9386f130f243e7cf8498"
    sha256 cellar: :any_skip_relocation, ventura:        "84414ae2013dabbd5455a3c82afa2ffab6f33db96c26726648259e0430b46459"
    sha256 cellar: :any_skip_relocation, monterey:       "c09ce554becbf3b814ecb1fa230d52261e702737fb7811770cb7a410ea0c10a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cffa8de5cea7c1437d65fa3e317281a44325e4cf5588b5d761a71e009f0381a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44cc80a846825756cdd3a3984e2c04f955f7a596b505bdaef43b5c8a1c906bb6"
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
