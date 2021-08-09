class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.15",
      revision: "8e41b76edf15f7eddc46cd75fd45d27a30dc9ebe"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "305a97fe97ba71a162d600c434b34305f2bd43cbefb0e9370a2efd369b2284b4"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ee6617c05cd4c0d16c49f1b8b5a5708af72ce9e0559153f30bc251eed1da7d4"
    sha256 cellar: :any_skip_relocation, catalina:      "704682ea3b389486d1be05d3ad78a6bf44235320a220891c76d6a8d49a7d1477"
    sha256 cellar: :any_skip_relocation, mojave:        "46fef9ab5f81a433883c452621b0fe0b96d53c4acc018eb8ee42d095d3abd9f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31b743e853265a6a9eba71830360cd73a90a9b3514176e509f835c57ca6bebd6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
