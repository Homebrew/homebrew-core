class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.26.3",
      revision: "0893f13b3ca6b563dd0c38fdebaefdb8be594825"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ec2e9e2a43a66b4bb40edcd6c09a03a7e74c1c1917f8e84e7efa2aa038a4027"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c241e1954a515692265e178ed505a7403ad7e420baf0cdd3867c2643c2746643"
    sha256 cellar: :any_skip_relocation, monterey:       "facb0994e6e532599a57a6dc2a38ff09d5c6f359cf6b1bbdb6e1372b19f76a99"
    sha256 cellar: :any_skip_relocation, big_sur:        "c218720dadeaef28d1dee43b3ec21fa99c88e6e41344ef769251969dd3df4520"
    sha256 cellar: :any_skip_relocation, catalina:       "2c85cab4766018eb0ff301a4c1ede711b254187c03cb2c3b2bbf410d6494e29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e0675e4568f2562cf857c9cbea965bd6931c473405024051ca7b2e04a4a9ed6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
