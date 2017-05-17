class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.6.0.tar.gz"
  sha256 "39ef8382d7557c4eacf9678feae42f473f2a9c436f4a518dfcf6a630eea6c2ce"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9172496c06f759401db4d4387380f508a294c05b14de9e92f6b61e21486c89dd" => :sierra
    sha256 "876d549d0a7cee2b0517ef3224c7d3adef6646548accd174d447e52bd0a2916a" => :el_capitan
    sha256 "e305dcd14ef5cec6d9d03551a7134e1e6c79e17676961c4dceda826642dfbc4b" => :yosemite
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
