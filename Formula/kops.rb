class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.21.0.tar.gz"
  sha256 "b6246cc58e5ad2c9566238bbe99ba8ba1e9593b016336ba5dd6320f66040ac40"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8ac7613c54a6be3786d95581b4fabbd291c76cda8966ba5fd7e9ee502c2907bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "61713a794e2aa636a8ae3fa12fc303390301b8dc4d975cc3a846a88ae4366743"
    sha256 cellar: :any_skip_relocation, catalina:      "fb7a06d87a294c221cf1b64eef189f74e9afec837e06cdc850dac05705efd0a8"
    sha256 cellar: :any_skip_relocation, mojave:        "6c8f3f1dd2af8f4674125dc257f0d3e499fd687bb3d2f081b77a61f342e928ce"
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
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kops", "completion", "zsh")
    (zsh_completion/"_kops").write output
  end

  test do
    system "#{bin}/kops", "version"
  end
end
