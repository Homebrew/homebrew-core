class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/v0.6.0.tar.gz"
  sha256 "fefd2d8255c59ecb94e326b7ea2a70e12005ac1aab4b1bcaca9dd86cc424679d"
  head "https://github.com/Shopify/kubeaudit.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath/"src"

    system "go", "build", "-o", "kubeaudit"
    bin.install "kubeaudit"
  end

  test do
    system "#{bin}/kubeaudit", "version"
  end
end
