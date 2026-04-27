class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "2d422ccb4f53131a1e847be349ab7e6f74856d3faa6716cdc332e002d72296fd"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf53047d8143436c909cf232df8d6f45f8385b8652c5048a44adba479a480195"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b557bc10a760fbd1f8ebd4e1bd6fc13739361878fbab37802de0c430d8d4f66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4837c14340eb4925a2ca6d0d7058c84208c996ad75bf1d898512b434d2718c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a09d4c257850d99a380a9d8dbcb429bbb943391a1676be9768fc572096272e07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89fed1d8bd8e74377ba293ee6429d62b974e6629c22d040a5b863c714335bddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "842be208e40f2e2a8e7d2484f78287ed5d6c3d2dbcc9cbf8a432e5c7782bd24e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
