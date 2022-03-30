class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/0.17.0.tar.gz"
  sha256 "98351b9498ea053887512cc98e63b4178216dd1e4ad73345ec215ec88dea33fc"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bad1e9aa367e2eb825b0fc05b6e7b39fa1acd7f8905fcc5dd89de3c7ff8c9c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "819f98d293fb3dc8db5e2d0e764f8f3ef98297e61e0e7f3fb065a08f1bd8c966"
    sha256 cellar: :any_skip_relocation, monterey:       "9b611f53c7ed25c4a1cd6f274f2f505b1e1cec52d9c2109d951e4285e9719d1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f51a42612debecb09872e6ab4f7837cd150dc8b7472ca875dd097c331330bb2d"
    sha256 cellar: :any_skip_relocation, catalina:       "25ff8e0cd8a67d5685aedf6e3c6f488fae5a9aefe3206ef5926cee5223b7834e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "854b237ba6a399cc64cc084ec3324be4dc9f47e80521d509b3b0680a10a1cb8f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
