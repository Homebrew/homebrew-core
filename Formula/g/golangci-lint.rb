class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.11.4",
      revision: "8f3b0c7ed018e57905fbd873c697e0b1ede605a5"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53978396717bdf98aacee970afed17a0c2f1f063f0315176047139304449873f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70dcad1e2f2f47ed36e7b70d3aad2114dabd80a84735ba3783127e365b8dc94b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b685aadd6f4ef58f34ff20be580b600de45195cbc2c615a8ae892c40d1816c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1736eb762939a228584e5c2272639ab59702261e2f29fe3e5a158dbaec8ba59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "833119a8e08dda4137904ee3035e1c5bc71ee2490e261d4ffb9948f711bc6bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8f4204a9e1ce04e797e2923ce67b4ab972e8d695a3eaa00e870a3042f4643ce"
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

    generate_completions_from_executable(bin/"golangci-lint", shell_parameter_format: :cobra)
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    GO

    args = %w[
      --color=never
      --default=none
      --issues-exit-code=0
      --output.text.print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func add is unused (unused)"
    assert_match expected_message, ok_test
  end
end
