class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.226.0",
      revision: "ecc59c7450956735ebf77ca0f440b53fb2495760"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cfe57fcfba206426d9431e57a19cbce9e94c763fe796a37c789974aca7532cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "852346e4e7c55571bbbe0745782fc9f73c763aaf6b03b58b527b0e9ba6486106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdf76db240bab40aec743d8a7ae460571ab9c0f85d46d09d20990cfe4c4e1ef2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f9f315d6fc3886deb1689003ba4a1beaaecd93c8371ccb675b4636e7820c855"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65febb2fe04e80a47159af84faac59329c2376c093e5fae7578d0e66cdd19019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a3da75e5a574536af3fa00b9f7277c47f3365d5a916c25ea0e63203cf9d6d2"
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
