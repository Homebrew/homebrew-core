class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.11.8.tar.gz"
  sha256 "7eac8fe79d435f4078d55e023315f0da2ee86db6c3005b55962ee051748f9716"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d4b2eb5ce9eb6b7ca61ce188878bc4b57b88de1d33937385661517c12e84d9e" => :big_sur
    sha256 "d5132b86c9683d1568b4e603f796b338de04b03140b93e141c48ccce75c3395b" => :arm64_big_sur
    sha256 "77543931b661a0ecfe9e0a91dd9b25c87fc0b54e70835d4db47e033f32fc0fe7" => :catalina
    sha256 "6deea8095f482a21689c036cdbb89766fd042c5b92d1c9915b2fedd797c904b1" => :mojave
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
