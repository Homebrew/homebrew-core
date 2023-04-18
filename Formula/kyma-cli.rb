class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.13.0.tar.gz"
  sha256 "686cb0d0594d85b290e111f44ccd78bfc74576e03f249527240f609fc12edb19"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "312954eb3ec784df6501c539047f6966beccda2bff8cc2aa3e7494092b1dd02c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf770fe3f4b5d2143812b7ccd4ebed92ab80f7fa9408de2c231a2c0ab20cc098"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68137e122d1ea28e25d3aeda4b8dabf82f92d903b48bcce8a2757eeaccdbf525"
    sha256 cellar: :any_skip_relocation, ventura:        "12969cfed87293e21130bb80429605e3c609f924d5b94c772014e1e4a96cb981"
    sha256 cellar: :any_skip_relocation, monterey:       "6d156e96ea1f56771c1c6260d3cd908893646c6893fb24b2694497eb0a82dea0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a707cd57e2b2c5a76b4ce2d901b4f13bf7083412d898d35f8de13935dd6765c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fbe540f43bfb065127e06d3c822d7f0f1df30b567e12037f8baf0c4d7866082"
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
