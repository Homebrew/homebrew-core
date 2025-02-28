class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "0.205.0",
      revision: "9e5300e5a3071f8905da4b54389d07ec09675fcc"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c656afc35b4b791a3ef39261633bcf417df65bef8e4cc0c18c46739515fabd27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cecf2c76be1ff2fa0e8d8b2ef0e493d5ee666a1343f26f0797d543d45c2e57e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "993b26cca82574f6fdb6bdcd512149b93463557b89438894eb1496848d5499f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c63342fea0cea69f578c909f35311a39d2f8fde4251200158c74d967b74fb3b"
    sha256 cellar: :any_skip_relocation, ventura:       "997ff2243b66f8763bfb680b8303cdc8650970c3beae2464324b3fda6d4cc4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a9ed7db6ddc245c000ad681f85a9c8d1ca1b4f88fccd50b377971a4470624ae"
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
