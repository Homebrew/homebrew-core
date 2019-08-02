class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.13.0.tar.gz"
  sha256 "d34ce916d72792c9c896c4c776c5e22e49c58c97fb2d9ae197fd93ecded88196"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51dd53e161a9bd5e6f9aa0e5e90438ae87363f2b9651b6b61379019d2741c782" => :mojave
    sha256 "13574e5636a468d474cd03b2d1d6cec85b3d9a593b65cbb68092d09e08cddb2c" => :high_sierra
    sha256 "ffd00acd1fb0e936303038d9bdf76c0ef3ee738ed3a4f07e1d3c0368f405f68c" => :sierra
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

    # Install bash completion
    output = Utils.popen_read("#{bin}/kops completion bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.popen_read("#{bin}/kops completion zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
