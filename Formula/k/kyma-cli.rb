class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.18.0.tar.gz"
  sha256 "6ba1706e60877a74e108f9a200e594750628dae6dac200d552c037599ae53e19"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e157a1082d9303dd726ec3bb962e96465e48aec7827a54e2ac1014bf94748d31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf00bc3dfd7981016cb338554d943f4681a08db89053532987629b898306858"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08855434550b87e82a8d2d4b5504cddb00b0b72fd60e44add13df1acae38a45b"
    sha256 cellar: :any_skip_relocation, ventura:        "15956266d3d4db7095959783d6627d0b10dc7d40f9ecfd6f27b94b07e7d703c4"
    sha256 cellar: :any_skip_relocation, monterey:       "99b9e47dcc85a49c69139ce808192dab7c8b64e8fbf283438813e370deda1a5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ca25fcdecdb0e4ff2d24b9b480cd214401323f1ed486769ca366082c050fa2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11a347604c8032eb36a33db70d74d82096c414f67a07c69293791962682075a0"
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
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 2)

    assert_match "Kyma CLI version: #{version}", shell_output("#{bin}/kyma version 2>&1", 2)
  end
end
