class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.203.0",
      revision: "00788c83782ee147c602698393d96ed50dde61ec"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c837034a688e9ba35d9bb117dd71b73466a18b494101b3ec78e0eef8d88fea37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29530c1956323cb5c92e8c36c3c75eecf0c63df6e93aaded3e4fa70fdd8ddac8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "283d4708543ffe32796b7feeade29c1201646f5c69e887289c437ebca5cdbbdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "580893f1a3bdfd9adfb8010a0360b100b93c512e6a6a19efa41c4f605481f2ec"
    sha256 cellar: :any_skip_relocation, ventura:       "08f50044e4f75419a55a1a7201a61f67ce262a409b610eef3d518b762dd72cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efcd6814978a781db4e305a197f1f0ea5b3feaa70b0610600bf5b489f6f8caa8"
  end

  depends_on "counterfeiter" => :build
  # use "go" again after https://github.com/eksctl-io/eksctl/issues/8209 is fixed and released
  depends_on "go@1.23" => :build
  depends_on "go-bindata" => :build
  depends_on "ifacemaker" => :build
  depends_on "mockery" => :build

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
