class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/v1.4.4.tar.gz"
  sha256 "32623441347845fca897b6fb1121466dc3ee8e6534c7582001f427ca4ac57938"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    sha256 "42f01019c571fd0e399022f10e209f9e47baf1357b815ef56393467cbee65e58" => :sierra
    sha256 "6bd50f64cdd384dddd61fd7c2ddc975ee2d97bffd16744f54b8608fd0d7266e3" => :el_capitan
    sha256 "1f740e8a4d1ca20e5e567c8880102c243dc95fb9878656fab99a0c2e1d438445" => :yosemite
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
