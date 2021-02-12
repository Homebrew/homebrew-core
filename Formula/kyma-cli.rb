class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.19.0.tar.gz"
  sha256 "5b010913a60e70fd04a1e63219e6446060e857f387cc74ca66cf846f3569271c"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2374eb6ec693d46e62b1b77e1642c45c5137a622350aa5b3ab52e5019c0d0562"
    sha256 cellar: :any_skip_relocation, catalina: "ef735c9c5d497af110d10cd2c7e0d96b9a101ad2e69e2c36f0ec50a7f0e1487b"
    sha256 cellar: :any_skip_relocation, mojave:   "973f107d736522d3d0e59631057985771b8e54545fd08686134423f6b6032e5c"
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
