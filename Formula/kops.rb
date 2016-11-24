class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/v1.4.1.tar.gz"
  sha256 "69b3c9d7e214109cfd197031091ed23963383c894e92804306629f6a32ab324b"
  head "https://github.com/kubernetes/kops.git"

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")
  end

  test do
    system "#{bin}/kops", "version"
  end
end
