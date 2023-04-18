class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.27.3",
      revision: "7c76691c389e4e7de29516932a304f7029307c6d"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "676650b54a8c08e9c04c0a6024a1963c39faf50885810328434cb61d947acae8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7ef5628f3121b7c0cbd9e514195a94ae7581bb30b17e3c79c0f5f381824c218"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c68167aa7240dc2468c500baec86595fae3c6c4d98660c7c6b112ff59b1e2bcb"
    sha256 cellar: :any_skip_relocation, ventura:        "e2316570881003cb7cc04b324e0fb371a9534e29e6deb4cdcb520aa113b07fc8"
    sha256 cellar: :any_skip_relocation, monterey:       "c4ed4a4d747fc859e8e4ce472b1a515d199970c56a1185419e312be28a50060f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfe823bd2e9e0e922cff42c8c8e060ea360326d8da6f98662b641ec3dc98b3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62f043981038ae411af676f23c4542dc6a68fe910c67947dbe061bdf679334f7"
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
