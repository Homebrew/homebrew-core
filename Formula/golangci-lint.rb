class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
      tag:      "v1.47.1",
      revision: "ebd6dcbf92973d7102593b5f4eec2ab10dac1e2c"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f389ad5ea8456215a29454cb1db6c194f3c70cc583bd3f2c60490b67b27ad1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e48d26cc1e08151f80b83c98a44ea01c2180c3763cb8db102c6b2e7c53e487d"
    sha256 cellar: :any_skip_relocation, monterey:       "8351b730b8462067d4c36ba9c081853b28857c575d25e0a4488e9778e8088d9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7b8490ac2c3da6ffc006ee86c86dc048980ad2780fb5d82d606628c65c233b9"
    sha256 cellar: :any_skip_relocation, catalina:       "46172d1c73e953aefb5083d838ac5a37ab02f36dbca3b4cd07c6dac54fc3b950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05529827221a12b3cc237e1ef8c640f11a488168e84a9e4eae4c0e92a2e637a3"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.rfc3339}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/golangci-lint"

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "bash")
    (bash_completion/"golangci-lint").write output

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "zsh")
    (zsh_completion/"_golangci-lint").write output

    output = Utils.safe_popen_read("#{bin}/golangci-lint", "completion", "fish")
    (fish_completion/"golangci-lint.fish").write output
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
      --enable=deadcode
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: `add` is unused (deadcode)"
    assert_match expected_message, ok_test
  end
end
