class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/kubefirst/kubefirst/archive/refs/tags/v2.1.4.tar.gz"
  version_scheme 1
  sha256 "d5191b3692c76b8ba2d371cdea0f29672738dc4c068dee98ff70e15e37fd8b12"
  license "MIT"
  head "https://github.com/kubefirst/kubefirst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fa94b1017764d59f56cdccd97a27a32c9f7d01f371404c78972b0678b3199b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa18b3f56fce7d1f39756ce9e2f1e4e725e169b78c6b1d0dd821df13b76ce778"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "764895948a185d0c850b1a1a66ab4e048aeed1ab1bd78c79ed5153862f244f18"
    sha256 cellar: :any_skip_relocation, ventura:        "1a68cb0220d0814d681a64246e0a1a5d34f4def95c2c2de0c19e97efd7741964"
    sha256 cellar: :any_skip_relocation, monterey:       "0b2096bff65e5eb717cccc3494e94110f453c37f8fb80ac218751bcd2d2cfb33"
    sha256 cellar: :any_skip_relocation, big_sur:        "36d905d6d0388a86c1f7b808eeff1f69c6280e1c2a8a259dc3dfce2a1d9e3504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c553c567722969018c658164b62278f14f6a9ba0d714bc4dfc4e5f0432dd1fec"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kubefirst/runtime/configs.K1Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    assert_match version.to_s, shell_output("#{bin}/kubefirst version")
  end
end
