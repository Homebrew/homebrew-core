class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.15.1.tar.gz"
  sha256 "b5a4a310b413d2db6dabdce8445c88db9f90cbf14e9b75568b0f0bc17d498741"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be284ee9ef7ba0a4cca6335e0d1455043441deffde5bf3df5cf2ad0f63ce36c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74f6c2b0e7b82ca87492e40cf7d3f1cae1264b0beac7e65a64d9b8558ec9ec29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f28f70ce7d52822489811fb245f2bae316c03ac21fdc1b50b69ba8c82fad31c6"
    sha256 cellar: :any_skip_relocation, ventura:        "7f06780e3e64531ba3e898023832cd7eb5ff224c4d257c0d373e739367e5bbbb"
    sha256 cellar: :any_skip_relocation, monterey:       "308da7ea3590b3967396ed8d3e952fb97a45c82125d4258f1fb3c176a2b7e576"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aff9aeb3182983a34aef1d73abd5d68397d172519944d9d90cfa21555a6cb9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37b7605a71bae49bd6292615fc15a1f5cf350d1c357f938eadd96c3c6a1a92b3"
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
