class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.5.3.tar.gz"
  sha256 "70d27f43580250a081333dd88d7437df5151063638da1eef567d78a04021b1cf"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9d97b1ef25dab016b885124901b7c9f5d96289db7d4de6a009cfc64a20c15ef" => :sierra
    sha256 "f0f8879cfee6fdf19946d119e911c141dce3e9296f8f9939de460f6caffdb065" => :el_capitan
    sha256 "cb67b8cff62f53b2cfab8511d088c755053b4b80ce2631dc4a2fdaa8383c6edd" => :yosemite
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
