class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.14.1.tar.gz"
  sha256 "2041ced36128484aabfff200955d1eb86d1dca708eeb7778d1aa347b298f05fc"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf7fb97e40d33d5e55baae4d62632e7df55655113db9119be249d94e5a86c353"
    sha256 cellar: :any_skip_relocation, big_sur:       "71b9458707cfea249b3b6fd7b18914fbbb6efd497f140f0133234ccecd1360fa"
    sha256 cellar: :any_skip_relocation, catalina:      "21883f6590403eac8d826fdcc0fe160a580954fcf666afa6c29e2244c1334398"
    sha256 cellar: :any_skip_relocation, mojave:        "fb90dc0cc651d0d9b86a5e294099cf8f98cc81df56e6bda3cdf6a39cf2765098"
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
