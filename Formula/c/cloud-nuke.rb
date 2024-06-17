class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "513982e09a270f8acc398a81f93c6a6af305b742b90fe5e55e7871320c25eef1"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "006c02ee2c0382d89e902233737b40d8f3215124289d812a2c8ecf9a022b68c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fcf618485e6b1c572fab5cb940d3e549af0a1504eda8b9fb6c823ee88350ded"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62e0ad688ae0075028311e8eb6c9262ca2d37264207ebf99447dd7eabac660f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f34f1af5a515558e4046cefbefa3e4cdcb0daed8b47c1f7cea55000437c8e703"
    sha256 cellar: :any_skip_relocation, ventura:        "d34f6e0ffde127263c9cfafbe75681c3342d2af0e5a0594ede92bf24824b700a"
    sha256 cellar: :any_skip_relocation, monterey:       "96e0214c6b50dba8c3ef43565dfbe80a9081c79f2cca1c149878e9a99c42c47e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e874125e5cb445184411bdfb3f356185979de9b89c0eedbc13115e83f9e5a99"
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
