class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.11.0.tar.gz"
  sha256 "0bba4b1bae6f6161f96049beed6452408195b393622290285569de740409e33a"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34075925ebaf9e93a37f7a069bdfbd0f29a0c6939974c40a7b0135b76190bac7" => :catalina
    sha256 "633e6efd570dfff2361bd4f17f7d5aedc484acadaae84e327a5ee3ba9e195f97" => :mojave
    sha256 "c6d2d0ae2e3150111d88469bc5ee0cd341be55c62389ba8eb11a24d46a437ee4" => :high_sierra
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
