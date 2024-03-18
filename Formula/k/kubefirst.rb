class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "c04e0f98bb2c811e9f9a868bc0bdfe4c5ba025832271df6033b795a061b19fb6"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dd12d5c0483de783598ef3fbc690d896ccb87c01c0fb4b2b2a3ea483175ceb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f665892447fcec7f77f5e276d97a8b5f662f17c83bab4ab45113e6387affbac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d30899d37a099e3ab4050a78068ebb31865ba31b73ed5fbbad044dc79e044ea6"
    sha256 cellar: :any_skip_relocation, sonoma:         "000320476116424d21c17f3d8404c5bb5e4919b6366f5bf65413d5d5dd27d25e"
    sha256 cellar: :any_skip_relocation, ventura:        "b86c86b0cfbf0136aacf5a39587994c72b4219d544fdb4f615c87e739b4770a4"
    sha256 cellar: :any_skip_relocation, monterey:       "af9597dcfd27ae9dc378f04ff01f788edae8de9e0615cda31d07b5ebf659ecd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "147f8dfe7a9df86145cabab8fee8082d0ee9da4d6e4ae788b10791ec03d9accb"
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
