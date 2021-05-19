class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.14.1.tar.gz"
  sha256 "2041ced36128484aabfff200955d1eb86d1dca708eeb7778d1aa347b298f05fc"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54fbc55d9d0bf2a0fdb758305de618febe75cfe1c0f5a71fff1cf9e9124f9f17"
    sha256 cellar: :any_skip_relocation, big_sur:       "6cdd08c1cb11b3d19164f0a3277ad3840247bf6fd64d2ea8c65d787f00929862"
    sha256 cellar: :any_skip_relocation, catalina:      "f71c456134a9b55f23670eff99d6190fd7db0ca10bfd72a415e0aa43a8caecfc"
    sha256 cellar: :any_skip_relocation, mojave:        "e1d85013ccb18da62cee8e8a279c61606cf34038a34b06ed013e068952ce16ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{Date.today}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
