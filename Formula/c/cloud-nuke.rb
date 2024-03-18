class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "5b76a3394281dbb81125f8160fde24c0447b2218425a6a07c95884f29b4130fd"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4aea72e92c0e600eed0bb74f3acaf04ca492bfae164a996483f974bfed12757d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7350a4c1ef536849cdd3c40f54769758e3c33b95e8e52e2aca8784a195dec48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64c501db0948e4ffcfa74dfda82b729399444ebc4f7ca4525a070af595cbd607"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcfaab4d6fe86c9835138539c1a3f2e3150f3c631d6450a3df993b4a31fb9de2"
    sha256 cellar: :any_skip_relocation, ventura:        "d2985d183e5fb54c58b32e342eeedcf3e79c499e6195c6b864d48d1ce617e8f7"
    sha256 cellar: :any_skip_relocation, monterey:       "5f94a7b86411be0748293152a5adecd6296d14f469abf0f89f27d4775411b643"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d4a6ba11a84f9c00332f52e2c0c681fa69ebc1ba365fddd7e9a1671fa84a85"
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
