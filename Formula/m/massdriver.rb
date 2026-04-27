class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.14.4.tar.gz"
  sha256 "086b6a6965d40677b5b4ab4daa21a7f40a0a600a91cd7f131ca83a8cd39dbf3d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9698c314548efbca0c5e155c2f0289fcd6d6adae82937366c403775ccf817cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9698c314548efbca0c5e155c2f0289fcd6d6adae82937366c403775ccf817cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9698c314548efbca0c5e155c2f0289fcd6d6adae82937366c403775ccf817cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "88eb4c0bd998c28f97f254ad26447f8ebdbbb3ea726181188b5552a2657d3482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81e97d07544ba63c4bd7c0bed33c5451128d7317873b0777560d36aa46e1bd6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eacf647330005b2e978fc6881d99b34c46a85eaec6b00dcfc33d324dbeb4b884"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
