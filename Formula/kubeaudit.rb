class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/0.16.0.tar.gz"
  sha256 "1f1c21352a5788586e5903dee499668d45318fb388b0cc3860b1a0d09bb489fc"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40e70895417e122f100867430efeab7a3650507464994f7dae15a37cf8965237"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abc5a62cd195ac34c9345ed92949226088f96ae5c5f98c79a71bc4b7cbcdb3a1"
    sha256 cellar: :any_skip_relocation, monterey:       "b029c1508a0ad61a8ef6f4560b525e55f4845d2904f0c51703f277e8cd4e656d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b4ed3572f96d0711f93cb8c234c732a70effb3bc5fb19b6a613816a7b3b83b8"
    sha256 cellar: :any_skip_relocation, catalina:       "cba9154ef5eb7e010fc19d955f813834cfb9086924b360f0c12bcad51f9ce53d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9968299f0b89a22cd7f66d7dea32b1eb73ef3d31fed1bed1cc9ccc6849afb513"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd"
  end

  test do
    output = shell_output(bin/"kubeaudit -c /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
