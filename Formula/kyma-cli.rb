class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.18.0.tar.gz"
  sha256 "698f693f5f70a7f2ff91831d6ef8fdc10d1ceace81e985b4c2ca02a73fddcc48"
  license "Apache-2.0"
  revision 1
  head "https://github.com/kyma-project/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9da6f18bf1f7481bd341bd9de2ec6c283842e5d382f1f12aab62e1b49796917f" => :big_sur
    sha256 "6e5722bc459a0ba3796038ee74937686dae941927fb395c18091c9a6b7c91f75" => :catalina
    sha256 "46d9dd3817ecb02b8f4e4dd60623af408c6b599c87fecee570291e3b62b93e71" => :mojave
  end

  depends_on "go@1.14" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
      -X github.com/kyma-project/cli/cmd/kyma/install.DefaultKymaVersion=#{version}
      -X github.com/kyma-project/cli/cmd/kyma/upgrade.DefaultKymaVersion=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-o", bin/"kyma", "-ldflags", ldflags, "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
