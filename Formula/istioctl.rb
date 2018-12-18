class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/releases/download/1.0.5/istio-1.0.5-osx.tar.gz"
  sha256 "98043349092853796d2eb2709df0bfd029689ffcc70c451dce04ec45f5fabc83"

  def install
    bin.install "bin/istioctl"
  end

  test do
    assert_match "Retrieve policies and rules", shell_output("#{bin}/istioctl get -h")
  end
end
