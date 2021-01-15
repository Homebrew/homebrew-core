class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.2",
      revision: "f929114ae4679c89ca06b2833d8a0fca5f1ec69d"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f1abfe7adcb179fae34191080e448524b45f94ee23d602bcc3c045e119731451" => :big_sur
    sha256 "4b97e560c2791134ed747798643bc013b6714b4d8470cee0b353c9460c305918" => :arm64_big_sur
    sha256 "de85ed24992be74b62bb7ba5c1585d8cf486b1c89f517f2934e207bfcd2a6f56" => :catalina
    sha256 "bd05c90c7a7cd58cf29419c0562b2e08213fe528b9e6af99e8ab40201f1a2cc4" => :mojave
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
