class Kubetail < Formula
  desc "Tail logs from multiple Kubernetes pods at the same time"
  homepage "https://github.com/johanhaleby/kubetail"
  url "https://github.com/johanhaleby/kubetail/archive/1.6.8.tar.gz"
  sha256 "c6c7ffa54d6f5d28b8c3fa6a6a505827f0a0d4887d8376d6fc605b1bf7c8ae64"

  def install
    bin.install "kubetail"
  end

  test do
    system bin/"kubetail", "--version"
  end
end
