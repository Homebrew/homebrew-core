class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.43.2.tar.gz"
  sha256 "dbafbf4caa39300fb8e6fae472f5f0b7f2bef33a6b3c5e538055c77a006dd7d5"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18e82c95d62f7ee00c05fc4da5f08184558b4e57c0f38edfef50cca55e6a9c41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d34d99cdbfa3b1e57b2c524fcf2d270c486eaa6a0b936bd3d8d59770b2ba433b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc1a5a8d45517392cd598350a129f9c78cb22042577b9f210f98a4cd71cbf72e"
    sha256 cellar: :any_skip_relocation, sonoma:         "cea2418596807b44d36f5121208be974f1e7802a57cc8125a376f66679adb96a"
    sha256 cellar: :any_skip_relocation, ventura:        "afe67a8e90369533dd71b1a9efd5b529d625e084ae839a0b207e981c67d5acf6"
    sha256 cellar: :any_skip_relocation, monterey:       "102df968b3c5196a04a3b6aa5e9e8de3e62a269ccf34642f9cd9230c20553039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d98ef6ae37d0e5ee43ffff35e52da72439ac67b4d2978028be02da1421e4edc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
