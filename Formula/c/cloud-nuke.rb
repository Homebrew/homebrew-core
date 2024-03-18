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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f73116044f20497d6bde38270dab3adc1f90bbd06f1937630c498c33e3568769"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1751dffdd5579b20d7f29d58a546ea70dd7951698b9d263b146b73b183871a4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20d0b379ef9342da1c025e9f63f462576f9b0d677997b22330a5967d6a7a5ca3"
    sha256 cellar: :any_skip_relocation, sonoma:         "71a105ee12a560b55d4154a404bb307dfc1b24a714cd04cad35d20eb076cd407"
    sha256 cellar: :any_skip_relocation, ventura:        "1ecdaa8766922c9f8cf9d77fbb9056b00de81e5a0211581e6afb2346e837593c"
    sha256 cellar: :any_skip_relocation, monterey:       "1cbd7079e5e8d88fc4b6e6db37ae4588144cb2bebb8443355d769541f63e22cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f542bd6c35d8d2ffe8fa87d819dcaa33033085f0c9d066424802fb0f900211"
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
