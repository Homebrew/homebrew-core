class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.10.0.tar.gz"
  sha256 "15d3368c12678cfb56ff2e9121d8f590b6ecfb6759ef29d33a8fb042b3979b4a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d15969e757d75e887dcec694227c4f9f7404311c762d1077b8755763452b5ca6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "369650cec87f63bd118400de2f3e6508aba277fc2335d910e19d4fcd91aaba4c"
    sha256 cellar: :any_skip_relocation, monterey:       "ca985a2dba31c88f751193a931c3c87dae7bd7a5c7f384576fe6dbb1aecc6d64"
    sha256 cellar: :any_skip_relocation, big_sur:        "867c8cb14d4ad1d9eadc56dd2d3670d0c9eb8b4595618a16eac639c15f7230e0"
    sha256 cellar: :any_skip_relocation, catalina:       "c854844c8abc000c843ef0ebe201e72514a955152024c18cac34f5b56a61e5f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3d5b06ed6bb515f4998022e806d68ab3dd77e55248bced0965ac53820409f06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crane"
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
