class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.13.0.tar.gz"
  sha256 "5fa618e837d0997cee4367d359ca2716015bf2ea1400e8bc68b1eeeba048d676"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5e3fb3c25d7c908ac24c5e99f49c00c5c9a15998110ec3f5f3abc64c149e1e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "eab5a3f327d8db7b9298bb1abaeba7c866504d077ac524d1b7584038ac1e636a"
    sha256 cellar: :any_skip_relocation, catalina:      "d1dbba7a528100cd55fb5d477cf6537aef9ee4ba2526f0f3789fc7f9fe574b68"
    sha256 cellar: :any_skip_relocation, mojave:        "8d9a85b4f5a1de6386d78f9ad79410c4019431de6f9b096c383ec6f8a87c8afb"
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
