class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.210.0",
      revision: "b54410c56b4c4056e4271b3a3b783bf9a357d37d"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "816904575e0c15ebd660c8519b521de60fadcdd9b357ccfa6aa57e1ec59eca66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d03d4a6375b0c966d575e23a3e037af0fba77f6d5be5dc369d586838c60921d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3b1534722ae4954784b4871f4420c5a873d0e9e4d05a73a411402b9a7a689f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "576ba988366d90aec5304384e7efad321caad30454a4d9b73c8f26056afad97e"
    sha256 cellar: :any_skip_relocation, ventura:       "f5ed8e48e52cbfeadbc815bfcbeaf8f298e1705b724922ffe8079b425e989eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58253eb90eb8264e1889ae789888118fc6bfa0ad539d92231c52256979bafb83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a867967b2e048a39e77cbe3ecf95888ab9dfaaf3307e5888c23b6eb80f0ccee3"
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
