class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "02b1f302bb40211ed65714cf0c1cb884d2d2b9eb59376fba422f86458d4e352c"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23c1a71324e70ec3d8a90443c3794beb3c75340d9beb75eda926783c014a9455"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7eef7e63781768284c69d8ea4cd49dd609023fa225d635a5a987f8089bc39b59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7bb2133e2297fa69bd30d0bc6495036a7ef30d6c93d340b06ae4a9ef7a3309c"
    sha256 cellar: :any_skip_relocation, ventura:        "ffa71596eaaa5d41a5427061993b964b7ffb8f1af0608fceab78b84b74eed3ce"
    sha256 cellar: :any_skip_relocation, monterey:       "2b0cb6f1c43e2487ac9d3d67aa7e969f6ac379d224b3c78c3e16da213a4db5b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ac71c6180af00551f940b87d7d569936da8e531e772527ddf35ee405e85e564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2283f8aaa17eb59c586c32b0af35881d3d54a87bdf90e2b4e52a95f31aaf63ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
