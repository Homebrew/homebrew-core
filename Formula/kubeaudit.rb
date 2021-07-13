class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.14.2.tar.gz"
  sha256 "b3ab3339f67bdb2c8fa310428feae9a203ea1c8458337474c4c452a0037bc44b"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf7fb97e40d33d5e55baae4d62632e7df55655113db9119be249d94e5a86c353"
    sha256 cellar: :any_skip_relocation, big_sur:       "71b9458707cfea249b3b6fd7b18914fbbb6efd497f140f0133234ccecd1360fa"
    sha256 cellar: :any_skip_relocation, catalina:      "21883f6590403eac8d826fdcc0fe160a580954fcf666afa6c29e2244c1334398"
    sha256 cellar: :any_skip_relocation, mojave:        "fb90dc0cc651d0d9b86a5e294099cf8f98cc81df56e6bda3cdf6a39cf2765098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a6ac23306781ac45b6aa4f8f2123cda6444b0d82ee025ab9ce1a51b53006898"
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
