class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "f927a39824963304e9faa75a22fd057640896f9c1db217814f7d825ee429b71b"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d17c21556090f5e25615f4feb8aea965d4132a697744909028a5a67625f71f33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc15e26a344ce0e05fd480f8ee87fd4f889e7d5b386dec93d9139f002a37fc87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f93af19dde4ec6820b2fc66735b1f240ef4c68e05a97d7cba41fd9a710065953"
    sha256 cellar: :any_skip_relocation, sonoma:         "34a456a9018d22602605c58cb49082adbb8e6c0b12c5db71363ce0791807907f"
    sha256 cellar: :any_skip_relocation, ventura:        "9fdf90914f1a5e4e4f0b37a5c6d4ca6461652e753ada73c88bc43099a9155291"
    sha256 cellar: :any_skip_relocation, monterey:       "c7decab52c684f31f88ca769b65a313bd24d74b2b0021efb1f3ae83276e72aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb8fcd2ba2c6979872ac8b479ccdf7b7cfa1b38fe02787e29de983cf790077f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
