class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.1.0.tar.gz"
  sha256 "70356bc4cb85ccaa66ab93b8eb5691c8f647a9fc85427bf1d076d867c5d150ab"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301861caa0bae43c01d3d6fe3c767a016f5d13b5d89f01237d780fc59ceb1e7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b5a04b1f90ec5e77b116e33e33aa7abfaa6ea72c9cba8ec84fdf6a2aa0015f0"
    sha256 cellar: :any_skip_relocation, monterey:       "ff6f405df453123cf7b96194c9264d51ee478dd2978b52fdec3fdcaf36d2236a"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b96a45e4af2612367505b3b33319a2f6d875eb0c516e1ce3c829bd5f2b590b3"
    sha256 cellar: :any_skip_relocation, catalina:       "2e8d4e775cfe160a0e4f7ffe5d48b917aa069a167be3c3231b2cb624347481d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23a392b3316b37f65050a19c862e321c75bfe1652e4836f06fa90b8de3a0c6cf"
  end

  depends_on "go" => :build
  depends_on macos: :catalina

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
