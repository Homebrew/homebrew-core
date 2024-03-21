class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "9bdae5a0bd1616ea72346bedb69d33a63bfedcc12eee406ea977c2a0ce7d29e1"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ddf6b63059e549d661a432b6e36751bba3f38d7455eee20506f2f15d9c254970"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bde5774fc2e0bf1cb7caf87b42bc94e9b28d1fbded1324b46056cb9fbd7a1362"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9bc5c3cbfb645ebfc344d0c183b21859ac8e79a5a613221714205be3a783634"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f10b43c7a49696606a16485ed4fd529f87ed108edf431ffafbac8b27341e47a"
    sha256 cellar: :any_skip_relocation, ventura:        "6d822a9b8d08f46df588609d3052f4c1ee7aab74af7f8a2bea493d06b949d1af"
    sha256 cellar: :any_skip_relocation, monterey:       "de2020a8ec337571c78a2af56c85b3e904e0a4dfb0f246f5b6e3855ef0351b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60c98089867d5806f6bda7e16c5e0f0852588adb33a4c640d798233d678b958d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    output = shell_output("#{bin}/kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
