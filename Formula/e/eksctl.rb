class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "v0.227.0",
      revision: "9c634ace6d66f43272fb82e73c4e658f7ac7c778"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90aa7f1071e2eecb18764a7cb825badf47587025497972b6a94cd26aa585380e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c3149f606853d71783bd3fd892e1134974231fed3ae823d1e23b4ab659b5097"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38ac1aa2bc3ec1a97d0e1549858ce6277c07b7828fe20639a3938e1c5628e7e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8df2f5c125d769fea208ac1fe761cf77bbf1ea3f8ba41d17ddf47a57e456b178"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7d38ea083c2d70e44ef335e434904b7b93a7fd6df03f6b8b33d38b1e2a8220a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41a752f4f9de999702052df9752c99a4382c9918349b00066feea3b9ac515b91"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
