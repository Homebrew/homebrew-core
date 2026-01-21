class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v2.8.0",
      revision: "e2e40021c9007020676c93680a36e3ab06c6cd33"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48a1896101fccaf8eb0e499fa57cfbccccd9bcbd02dac1e21f8588fd62db1d7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27b696d692604a802cb4e854af48cf63b84f90f1a57fdcf4492cccbb32728edd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ccc525927eeb9b9a4818ab08de8afc24cbaeb0a36d3e8b229c534a1c401361d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7e19fc5c021c8221b8a4e659289447a131505c21cd94f467c396a097aaae94f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96e0a07ed2009f86e638aff478ffcd1ee0b2a07557a7e08dd9bbe0e94f2c991c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1a68dffae26d225a535a75814790c762750b5e3706ea90643e7ebbaa446db0a"
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
