class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/0.17.0.tar.gz"
  sha256 "98351b9498ea053887512cc98e63b4178216dd1e4ad73345ec215ec88dea33fc"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "172262ee505a8213747a2e387dae92df3a6d22a56820902cc1bb655a7628e127"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f37e49c9157af8581e360a814027671056e821e6c7ffa95d568401df5c21c4f0"
    sha256 cellar: :any_skip_relocation, monterey:       "8aa86beb7f6b294170adf80bfe3994ec2b53897e2aadf6221cc0ee8ce07d0a70"
    sha256 cellar: :any_skip_relocation, big_sur:        "76c174f29a633a4cdbac9e754d4e93646d352eafa45ee2cd98ceae02c4e7f6cf"
    sha256 cellar: :any_skip_relocation, catalina:       "a91b4cbc14435a900fe0775db6a6ae348df31775cc4dbd5ad2bc53ed126d30f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50dba55e6d91567c8676599ecff11392e246520d021353cd2330f7920ea18fa7"
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
