class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.6.1.tar.gz"
  sha256 "842363057ced88097373af49f5306a20192c7c92570e68964f2d1c0cb9ea1285"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "215d2aa67a79c5f5f45119b378e4a956f0ca178e0981d47a116489e8e5bdb230" => :sierra
    sha256 "32fa250ad4aca6929bcdcc53e078c7322891a003233aff0bf88f2eff23873c28" => :el_capitan
    sha256 "e774f9891d3f7c850e9fcbb17b305289c689907ba9bc7111fcf0c6ea96c1f3c0" => :yosemite
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
