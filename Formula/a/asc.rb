class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.4.0.tar.gz"
  sha256 "6641a2f9675c999d1e452663155aa9304e950fd5d4dc1d2d5753fc452102712b"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5dd96575cf1dcb94f8bb79725f6e8ba9ba6ca1418bd0995f71ae3ab907ecb881"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ebeead6746a372ce20473af3ac327987fe5ae3a1bc547765e7ab48a98e1dcd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ddabf92d2c907252ca616db826e68ae74aa4aca2dc528ed54bba03250178c66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e2560014b605d1df7d4d03215dc436114220e2038171eb54603515a11d1da604"
    sha256 cellar: :any,                 x86_64_linux:      "ecfe72b5e262543f527dcd05fec62d60f6f3f2d05aa81ee101a3796e98d2876d"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
