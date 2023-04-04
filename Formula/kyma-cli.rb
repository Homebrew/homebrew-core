class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.12.2.tar.gz"
  sha256 "dd2b4e53b9f4279158ec3d8de715b860d05a3dffb3d46d4db69bd13b649d615a"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c03c5e8c7ebb4316f208b493024a3322e277f0de12d51ff63e492e903b5860b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c363420589e1e2f67f5def33f36e6506c4e3092e84cfadbbeaad13f62593d82d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8adc5a37115c02e7aa3ba6500674eb013d7374e12728e016a2c7b3e2bdf3d1a9"
    sha256 cellar: :any_skip_relocation, ventura:        "468794260832ec8d2fe0815301215784ab5ddec52afa4633e782bd0732a1884c"
    sha256 cellar: :any_skip_relocation, monterey:       "fb09294c67a8525bcde6e15cd7bed318e178ff6b22f0fd985e846ff76bfa7334"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d2c6eded537ea9ef896cb041df67c4258c324d7b01af969db041cea5225ef38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b35107619f54b4c3505e4799c09d8fde9e398c77d3f8f9fa3740efa7acc750df"
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
