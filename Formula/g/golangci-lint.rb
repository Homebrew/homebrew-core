class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.59.1",
        revision: "1a55854aff4ef60cd8c4e709b650b281303ca7aa"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4fefd5193137e6f5220fc4affd461f06eaba55a750598f9888535aaf1a2e1d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e11d6b733353a7f932a3415eff6ea5029a9959f33a7b423a0b116accd08e263"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10a5d54944e91dd1a14af280b5d0ea5916e807a96fc4d7dfee9bc21c1325b316"
    sha256 cellar: :any_skip_relocation, sonoma:         "44a753e54c295bfd7608b5480995d24d4118ef6510da3ddf3a2dd1301bf12ca3"
    sha256 cellar: :any_skip_relocation, ventura:        "21664bf5c5d729c2186fa32f357d4dab76cde35d7733ffa22bd9c55ecc8fabe4"
    sha256 cellar: :any_skip_relocation, monterey:       "fb813bb4599db4a550800c2580f3554ce8539f7020347e74210b3b9774943e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce6fc162775a5c12b9e1d3f93510a8db9467840c2f659f843091b0d20e6510a3"
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
