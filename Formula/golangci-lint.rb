class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.51.2",
        revision: "3e8facb4949586ba9e5dccdd2f9f0fe727a5e335"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdf268f8fd6a32c0370d5d99a637695cb257b332680457645f9075442cde6b77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fcc71e3f38320666cf82f835e2eb08f7b6d0c378119923cfe4200c336c77f4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f6e916176750b25b9f40efc44def1fb4e1bb8d57cada2230b81a10e2125b04b"
    sha256 cellar: :any_skip_relocation, ventura:        "f0148ad86e73e2e24044e5c950c66b8ae3fb11b62a180cf288c1d03082c6d21b"
    sha256 cellar: :any_skip_relocation, monterey:       "fe94db20ed16316ec439093c29248773376b7d6d7875458954210a363c1e186a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb175cbe4080fe45392971723061c80e9b392f58e34aba3470d1e39f581b827c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8618eeedb762db3649e4d6339894caf784e24a6bb98c0e6d1bcf53436a86279"
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
