class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.7.1.tar.gz"
  sha256 "044c5c7a737ed3acf53517e64bb27d3da8f7517d2914df89efeeaf84bc8a722a"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94c49903f69f14a083705a29961229961a3f73d77b33f802b93df58213e77f11" => :high_sierra
    sha256 "16b75721e8fe53adbf28fe42d4db4ccd0cc6d485c6ce67eff539dec8e3e94160" => :sierra
    sha256 "e50f6c6f6655c7597373aa52d307c6812fe7504a48751e814a820b2ec198e6ad" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.8.0-beta.1.tar.gz"
    sha256 "81026d6c1cd7b3898a88275538a7842b4bd8387775937e0528ccb7b83948abf1"
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
