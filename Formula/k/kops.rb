class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "e681e1b52bd7b2edca4928924401671cf7daf23636fc077471b1b8abc6fdc255"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb371dc0d61d235762611237547b528e7bdfe480d91ca6bf123eaa6f4463935e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a780c1d9f1aba38a61436bf58d825753034ad4ad7ef266fe3577ed6b0e80100a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5c8643682cbedd70dfd6f43cc186978c0e09a6121c2d13d0c1d9473f6ea0c8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "aac2a598b8761ae2e22db8ee782b562d4d5243757ec388dfb7699e9ebfe91579"
    sha256 cellar: :any_skip_relocation, ventura:        "2555e47fe5ede254d06e3ca2db227bf1da33b546db6a69d44c9b4758c482b4d4"
    sha256 cellar: :any_skip_relocation, monterey:       "26516c0d147a5736d385b5dc5ce6ac65a1de5380c2be4e2d4fce8de5ea5891cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d26681a0eb97ba44a73d4f5f0018dcda3d10d80ab7828d1834e2c53e793953c7"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X k8s.io/kops.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "k8s.io/kops/cmd/kops"

    generate_completions_from_executable(bin/"kops", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
