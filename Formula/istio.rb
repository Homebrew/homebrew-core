class Istio < Formula
  desc "Istio configuration command line utility"
  homepage "https://istio.io"
  url "https://github.com/istio/istio/releases/download/0.5.0/istio-0.5.0-osx.tar.gz"
  sha256 "34c3f2cab1d25f99dd8b411e97c7eb5a527d44c77775ff0ee4c26ad531564373"

  def install
    bin.install "bin/istioctl"
  end

  test do
    system "#{bin}/istioctl", "--help"
  end
end
