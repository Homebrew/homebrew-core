class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/2.4.1.tar.gz"
  sha256 "07eeed96c8b9886e57e3b283c37c8b583ea45188cc19f7826d0737c6102fbd08"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ddaf2327994fa4495d6a64b4d2fdf00ddfeb70a4298a3e88f347ed2649470fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5ddaf2327994fa4495d6a64b4d2fdf00ddfeb70a4298a3e88f347ed2649470fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ddaf2327994fa4495d6a64b4d2fdf00ddfeb70a4298a3e88f347ed2649470fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d00cf5645be9a5dc79bfcb9503964167c64d29cc21595dc86ee3b10d091055ef"
    sha256 cellar: :any,                 x86_64_linux:      "c4105798ffc5f5237a0068ed4ffdbdc829717823d2fd24edb9116f45443fa3b4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
