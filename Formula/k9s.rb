class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.22.1",
      revision: "2e04a846e668f67af207a1030a310b5e2c864231"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4782d3c54244169d37b869cfa0d4cc1a89ee6e7f60f01909f1b2978573009e16" => :catalina
    sha256 "038eefd009c0438ec93da9ef6fe6ab3c410ec72d11d388501bbec8a9429e9e71" => :mojave
    sha256 "359d268507759d846acfbb73645e892e1fd9081c35b965a80087e1372dcc424c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{stable.specs[:revision]}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
