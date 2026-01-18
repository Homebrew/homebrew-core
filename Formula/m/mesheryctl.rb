class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.8.199",
      revision: "c2466f0f6d2d0865c6a60da80cdebca228128eb4"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74e8593162e04a4e919dabac18e6f941adc869002eaf22c30ac16e8de19f3c06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92b79f6d4b4c3bf3d58cb3b5d389676ac0c114cb42bf87154d7c180953865ac6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cff12fff89cb8410fb11d4e3d9ae36513f77fe7505593086a00ff0e8cf47fc69"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2da7825144e124777cb98fdc46060b698bdb37a9fcf949ad745b1f4a76e6825"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "968d4448cb66553e785fdcb4326ee19efea7fccf866f314f0bee4733329ebad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a422126cd7fc3873a93eff1bae8075f9bfbda0b82b5a5054adf5e60a0b464042"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
