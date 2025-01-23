class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/harness/drone-cli.git",
      tag:      "v1.8.0",
      revision: "bb3f656485ac8c289fe85b9f62d59993ffabf6dc"
  license "Apache-2.0"
  head "https://github.com/harness/drone-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "32169cc3c88c8673a10a0667ad401d8ec22cc38873044b6da6dcf5ebe92d9d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fc8dfba68da80112f85551c3dce05fc6cb269a6ae4a4f4aa7a1732d8098a85e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fc8dfba68da80112f85551c3dce05fc6cb269a6ae4a4f4aa7a1732d8098a85e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fc8dfba68da80112f85551c3dce05fc6cb269a6ae4a4f4aa7a1732d8098a85e"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdb5c00c40d6176cd7f9dcf1d5d2e16bd73301687f8feca565f6ac7ab99b5651"
    sha256 cellar: :any_skip_relocation, ventura:        "bdb5c00c40d6176cd7f9dcf1d5d2e16bd73301687f8feca565f6ac7ab99b5651"
    sha256 cellar: :any_skip_relocation, monterey:       "bdb5c00c40d6176cd7f9dcf1d5d2e16bd73301687f8feca565f6ac7ab99b5651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9f53894149db17b3bb43aeaf2b72cf81f4d9f564fe810b1e7ec241645a5be2e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"drone", ldflags:), "drone/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
