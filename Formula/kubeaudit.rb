class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.12.0.tar.gz"
  sha256 "5667fc8f7197e8ed03406ee28e0d2efc93819226db019f009db6cac27e93b59b"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08f2c8540db0020a5f88a9b5d4fa2d3f53558766587b3f68891ee8d454e7e401"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b3dd8f651bf05d1dbf3a026e0882aed226e96e1fed043b625494c20f021fabf"
    sha256 cellar: :any_skip_relocation, catalina:      "7aa43b94f9544018f5d5af233146e843f35deb9b76c6a01d8fe86ede1f13dcf1"
    sha256 cellar: :any_skip_relocation, mojave:        "dc93207e1808fad38e06a08b11a35fc9bf4dd381cacccc525ade4534ee44287e"
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
