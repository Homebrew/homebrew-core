class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/refs/tags/v1.30.3.tar.gz"
  sha256 "35aed72e9c693d30ecc6a3d4dad054b5c1bbf616dafecb66f4cdb22db6d7b11e"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a71f602bb1d5e7e13e2c97ca26693fe960f0a6dd450a7adf2dd67fa4f6e07b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4277ee6fef2229ca72196f9a38516b2b2e78e967d2808ba23a32e9e98e37717"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1d1759b18600af1e327bc259786ea3442c6be55db636294d00fdcd719c1afbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "daddba192751396a73512ecb8bea73b9f4dfad4f17a2b42b1523a2ef5aa54217"
    sha256 cellar: :any_skip_relocation, ventura:       "d5636bbaa077576b67a18c2f8773aeddd0da7ed3fc5951838ade124ebaf95e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1290ef930ae52110b53a4205492cc37a18e6b9533ce21b36509d871b971763b"
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
