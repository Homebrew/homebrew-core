class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.7",
      revision: "303de07663dcb20899852a98d3ebf6ce2f1c7922"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56a22471606a3514eb4f65a23492f199e3876459da202811016f7e59c1ee66e0"
    sha256 cellar: :any_skip_relocation, big_sur:       "872f1f83bbc5e51247f28393c26b1f8d7774e8a4086855736810076c17398f23"
    sha256 cellar: :any_skip_relocation, catalina:      "af37a22da0b088ed01df459e3dcd2ef4b952eb0998132ae8fad75b2367b8a191"
    sha256 cellar: :any_skip_relocation, mojave:        "06b633993e49dea023f1904d6ac5dc22e702b9376914aba6861feb87e702cc09"
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
