class Istio < Formula
  desc "Sample code, build, tests and governance material for the Istio project."
  homepage "https://istio.io"
  url "https://github.com/istio/istio/releases/download/0.1.6/istio-0.1.6-osx.tar.gz"
  sha256 "347904068bb6100aa15b2a030be872687143b86d8529c790212517405ddb0582"

  def install
    bin.install "bin/istioctl"
  end

  test do
    system "#{bin}/istioctl", "--help"
  end
end
