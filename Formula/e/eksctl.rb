class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.208.0",
      revision: "bcdd6ecb06ba883c96baa7d860141896969a2b71"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1506845bc0f202c87f19d263ac9ca7edd1bc92ddc123c289a0a06d680c23765"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7584d214f35e533723078c611139fba9173f6fea49fc0fcc8a037a21193e3e64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b2b6728f05e11e1f150bf67d863d16ff7d2639ed32888222c588fa51dc229e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "99ff481cdfae7273a3bfb1b2b17999769a1a9f01388f64f0b07d395f5940315a"
    sha256 cellar: :any_skip_relocation, ventura:       "fb1a5cf665761792e7d71b152d658d518229687c54dd4bda4382ce694d2a24d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f1151fd9211b8c4fcef5b4174b601098eac28c06fc8c88040e760232073513c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3afafe1e8ac3fe12a4026d1c2dd0c716b9212b737fc50694037e9a62db41919e"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
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
