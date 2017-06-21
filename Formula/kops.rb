class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.6.2.tar.gz"
  sha256 "ec0444177089022690244755578ec664bccbdf61471974a683637aece45a7978"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18f418a4d06b4179c0146bde8bc7ef79b954813ed209f2445464a392e05f2d09" => :sierra
    sha256 "1c9a76dedd7173c6d4540ede03142b7f74e594bd1f625b13ba6d9340d642eca8" => :el_capitan
    sha256 "5c66416bd9a4a2a8a931f13cbaacce9bfa9a9626ccfd59da6afb5358f16c2ccb" => :yosemite
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
