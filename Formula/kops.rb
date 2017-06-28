class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.6.2.tar.gz"
  sha256 "ec0444177089022690244755578ec664bccbdf61471974a683637aece45a7978"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a823ddda2f1cd9aa70ffe25e47aa8abc004879c2a8ba85b7c1b8785b4db03c76" => :sierra
    sha256 "7bbc03f8d61d66500c6e99896aeee3df68ab60d3deb7d939f437d6483c3a3025" => :el_capitan
    sha256 "a03dc5dcaa4de363f2db10dc33b0beaefa8dd9f756ca3440910361833e6117d2" => :yosemite
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
