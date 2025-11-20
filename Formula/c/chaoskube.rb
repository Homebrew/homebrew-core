class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https://github.com/linki/chaoskube"
  url "https://github.com/linki/chaoskube/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "ee2db89df0136c86997aa867951010e901f59273d840ed43a826d4d5fd89bd9d"
  license "MIT"
  head "https://github.com/linki/chaoskube.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf153893fbed4119d54ae61ebc6fb88b744170113ed9836dddad1f010fcf2ccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36f62ac923f7050c352df7f8ec5068a18987b997c9ddb178ae4e1855da9aec6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "435adc6fb662974a4945b8188eb64a69c906e54c8e2e9d47cf63c34200422b79"
    sha256 cellar: :any_skip_relocation, sonoma:        "48a6e3c9d3bc29a859fd5708a788780af9c820457076578a6d45b8a4c7262bb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c497205d2196f6073ce552f34321bfee4198ec338d3da8c376fcb1c9885e41ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f4ba35835dbf476ee584b33bc93e97a02f28a250598d8d8b61e397656ad3a6c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}/chaoskube --version 2>&1")
  end
end
