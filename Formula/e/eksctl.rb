class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.223.0",
      revision: "7a9410b8dbb499ec6cc5fc4f690d4bebbcc95289"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05c85207ddd744063e02f78c3310fbd42c6d92961a3ccfb8f4d2008223d66d42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5276fe233e57bf0bf2e95fb2be15ad8bac96b84b7dcc1bac4a04fb86f6a6e74c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620d5c5bba59aecbec5eb03ab3aa3321ff17d56af23b6ab727d1fbdc249e4c72"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f9cbce57144a1e31da390683e5590d87a563c951bcfd40f26761f96b400fd74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb486230ec1382ebfd1ad4507e612badbf26562ce44a67ec1fbd7973cd89e1a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1284d326eadb742673c0a3da7fada6d85a6ac7e54920323c2c9e990c652dbee1"
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
