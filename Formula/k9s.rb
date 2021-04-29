class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.8",
      revision: "627c38cb360f7a9b6eb5f856c7658838644d1540"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "961e6cbc9347c7ae27203185b131971a200eee5b1dc60aae796c91660c444671"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9c764ec0eb2c3b626fbd4e1c07e6731fc03deb73fde88f8a18e8226f4e8709c"
    sha256 cellar: :any_skip_relocation, catalina:      "e012b5decd95376303ed3547d0b42dc62864e8d7c700b73d9bc355b3f7a03f8d"
    sha256 cellar: :any_skip_relocation, mojave:        "94e04bcdcb141d04583559e88dc6d4dce1ced15d0e4db9059e98cdb76c660cfc"
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
