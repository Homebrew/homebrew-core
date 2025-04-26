class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v2.1.5",
        revision: "8c14421d29bd005dee63044d07aa897b7d1bf8b0"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c112c4d80585573635198aa8f0c56fe6b7379e9718a5f83d4d663c09aa85c9b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2a84a108efd8a02d35d9d4b3872b81bf31799a35516bbd300570a9144e7756"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f695e63529d468bd199bcd33acbe9a2201051fab958c47ea38f60702a3bff16"
    sha256 cellar: :any_skip_relocation, sonoma:        "facbe397b10f186390442afc0a4599eec698cc19bcd81eea5c2a303af36c684c"
    sha256 cellar: :any_skip_relocation, ventura:       "505e7a1c9f9ab71f67533608ab2b6a5ebba7413ee4ba354969531eff2a48523d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82a51127d654abb2f3d3214866bc3f634f2608311940dae8a861575368bb3857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea50bd2905f97de8cc9dad3aad0f8bd3f1a6eb7392467bb63248672d639ef0b7"
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
