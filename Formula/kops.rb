class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.7.1.tar.gz"
  sha256 "044c5c7a737ed3acf53517e64bb27d3da8f7517d2914df89efeeaf84bc8a722a"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a55d7b5325a73c1eef3692835d6bbc1d1eba5cc5d53dd786d67bbe429ff04185" => :high_sierra
    sha256 "56df1f833bd82adf5dc00cca955a62a22f4f4326b1fd31faa6f98ac5a5cfae7d" => :sierra
    sha256 "05e80372bbe20a03af8a81656fe628494aac03884056f623d22b8f11dcf5b26b" => :el_capitan
    sha256 "ae2be83766d1504814abb7aff7a44ed1aa9400915590f5f81f01bd94d19fbe41" => :yosemite
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
