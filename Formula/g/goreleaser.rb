class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.20.0",
      revision: "b8f79e0399c46895220e8479e24d599576b563a8"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "430dcc9000b3c174fc49781bb67729f26709c77c5592d0b578882d537f857a67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b23a838fbe8f513543dc555402fd9305a4f4356b9984f2436395a9558dde8f01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2202a8119eae3a3fd6b84b3138d1163a22be8bde72ae3efe592e95041a9927e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3deb7dd87acf9fbd2e99d7987d52abb88b06b7564947d98ab0a8838a0944a5a1"
    sha256 cellar: :any,                 x86_64_linux:      "b081fe7dbe6adfedd6842f89df1b76a5d63d2734ceac5de6a4a5fc13aad4c095"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end
