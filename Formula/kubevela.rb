class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v1.1.5",
      revision: "f95ff4f06e9f29c02c1600691b320a50a12008fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5cbd826d1cd531b3c92a6d691a9d9efedf430bbefaa502a88f57d56d364b1ce"
    sha256 cellar: :any_skip_relocation, big_sur:       "c07e19152c0d21f3cb29d938217607bb762c64be19265063a7b534714e380ec8"
    sha256 cellar: :any_skip_relocation, catalina:      "d8bd7c300316272af768c02de34ce458df3bc23cb05a689aadfc8d1bf51419c5"
    sha256 cellar: :any_skip_relocation, mojave:        "747580e6f9837bc887eb1915abceb071422df9692643c59493179c2a84f9ae49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1bf4a68c86889ceff5075dc27d605a56b57292ca456f647cec1f6e9d961d4f6"
  end

  depends_on "go" => :build

  def install
    system "make", "vela-cli", "VELA_VERSION=#{version}"
    bin.install "bin/vela"
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "get kubeConfig err invalid configuration: no configuration has been provided", status_output
  end
end
