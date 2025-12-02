class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.220.0",
      revision: "3f73c725ceb0261368efe512efbea6bd20b7a250"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "750dcb83973894ab85dcfda8d72c8dc6c9c8c312c05184fc809081f92bb6ea57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a7bf486a21086a49bff3715b17894770e3ffde4f83a3d1b596e2ee6f2ef26f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f96d96725bf4cdebd2c10838573b714895b35de6bb5546c53e3910d28e2fe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "223bcd3b94223f847685a375f83db212af4ee0a07559873ffa93a15a34357c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07fd7586e6ce9959cf11596a9fa7bb1a59ffbefcbee40ffe445af14557c217f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f37eef03f430c9ad767bb8e4aed29e7bc3387914d23e90899080d310b244a38"
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
