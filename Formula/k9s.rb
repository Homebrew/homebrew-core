class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.6",
      revision: "0b965ebf4b1d871fd6486d6176839afff61e7104"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "85d6dc47f2b29749c9ce43d80299a5ff38a5b5b1732d1ae165bcf6d2437ef1f0"
    sha256 cellar: :any_skip_relocation, big_sur:       "74b8b7ba0ce48f14f1e3b970e02f0f9b7cf44063ad29cdf62db0cc7161be1164"
    sha256 cellar: :any_skip_relocation, catalina:      "6eeaca5f6841241186701c085a8ca7287e49e3917d435a18b03d332496d41481"
    sha256 cellar: :any_skip_relocation, mojave:        "a669301e9599d1e17e5ef69ca2ce792e9e48e01da66318a65412db17b99e7cf4"
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
