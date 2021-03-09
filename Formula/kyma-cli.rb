class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/1.19.0.tar.gz"
  sha256 "5b010913a60e70fd04a1e63219e6446060e857f387cc74ca66cf846f3569271c"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "f916d2e34ce347f5e9fd201a348b787477f154d553dd54a2f9108dd2bdfad816"
    sha256 cellar: :any_skip_relocation, catalina: "7cddd24bd0f447a412fcbdf262881b2b23d94065abad9557c73185655fa64191"
    sha256 cellar: :any_skip_relocation, mojave:   "404fdac1b20854feeb541ced5f29b751d82863d75761dc3d6d1eb4197664be3d"
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
