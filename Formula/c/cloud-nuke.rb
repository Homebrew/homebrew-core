class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "a3896893005844f1be0c4de9f13f3a040257fbb7bbfbedd876bc5193882663ee"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2937f79e295bb7a75b1e0c5d9d6f010308523fbeb0c0254b00913dbbe5f81ae8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2937f79e295bb7a75b1e0c5d9d6f010308523fbeb0c0254b00913dbbe5f81ae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2937f79e295bb7a75b1e0c5d9d6f010308523fbeb0c0254b00913dbbe5f81ae8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3cfa5229d2f049d38c0eecc7e578dae23e5cace47f0c0d7c42fea9db941ada6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "391d109bad3758f7bb439175276e03f8f6b9b19a52c1309285b1c6f22402ed6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a41fe54b15fedd197b1dc4f47fe67549726cca4a425189166de63cb7b2ebfd9"
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
