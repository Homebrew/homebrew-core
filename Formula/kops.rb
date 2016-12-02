class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/v1.4.1.tar.gz"
  sha256 "69b3c9d7e214109cfd197031091ed23963383c894e92804306629f6a32ab324b"
  head "https://github.com/kubernetes/kops.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f174b175d52e45b7d195ea231a6e970841e770d1f2a62385673425c596e59e5b" => :sierra
    sha256 "aaf16240625675fb28c46d357a0b25f4844e56aa881c987fa7dd03c521087477" => :el_capitan
    sha256 "9edb1edd290e6e0a39bcad0177f2adf85d5cd9c030c4621efc01e6dc90517877" => :yosemite
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
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
