class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.8.3.tar.gz"
  sha256 "98c51598b9724ae194c0c2c9acaa05b171db01aeeff7be09da334b23a26e6c9e"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bee0aa1927aba8322e42b4c3822fd3c13e9cbaa0ae677e456e8e7f19168c006"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9d59cb7ef3dddee20a5588459ee1da159951248773d423fb70f947534dad413"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c159c8ad8f82ca009bd8e506d4a5efd5fb34085b50ddb3d8847a3d1b97b729cd"
    sha256 cellar: :any_skip_relocation, ventura:        "ff60e0527e7636b142bdb65d8f24faa7eb003f32a5055bbc88d91f2de32ab6df"
    sha256 cellar: :any_skip_relocation, monterey:       "54779d833cacdb31e3e2961cdbceb4736f06fc7f10393ccd3ac6d270aa3ab8b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "41f94f417dfc0c668b0ec3474a2839d5215f5e4635a2e189447d04ba5cb2e380"
    sha256 cellar: :any_skip_relocation, catalina:       "635150e80949fb8809b5ec925c29f23041b2a991870e36dc66d2e7fb4d3fa977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5affd4b19ca7d921bc4b8f88e87b8c18bd81f278be6866490af484502eb795f9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
