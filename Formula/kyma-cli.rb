class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.11.2.tar.gz"
  sha256 "460ed5b6a754046271649493f425859a0f1ff01d59460baa8803b6e1abdfce84"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02e28fa6cb63a724f2dc53e4233f9ef8f90d8c46f9ed1cc0fd91649d2143057e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f4771a6a8aa74f42694b72eb6d356963bde9bb801910588953f45c3ae94cc8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b637274ef6e89a527bb23ac35a3eaf51e74a1ddd9d8c2deace1d1f5da1d0adb3"
    sha256 cellar: :any_skip_relocation, ventura:        "5c56d480f0471043497e0edb40a03c3edd2306486b347199c6306b6c3b76d020"
    sha256 cellar: :any_skip_relocation, monterey:       "27c3a79d7b24794cab302bc7341c0f3e3da25739a6fe002bd637e7b0ca296b40"
    sha256 cellar: :any_skip_relocation, big_sur:        "19f5cd7e448d7d93062a8dc31295beb9ba94770ff4800a34f1090ed07e6bd827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "936ae1fc5da1f4b50e20847c0293f5ae1c9de2c3b0306056705e38be56cf167c"
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
