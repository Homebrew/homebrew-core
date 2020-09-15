class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.22.0",
      revision: "58d2bfe9e36286bd20fc7c8ab5c8353524a71642"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "675b90ae1dc6546a8bd465a84c61b766860d213c31d667ef097239a1195e8ce7" => :catalina
    sha256 "4af0e81087bf2bf8e2f21ccee7c21d8a6788f50d9217f6da247e7cf768f8abf0" => :mojave
    sha256 "e3c78fd088866d420f768b8ccb925f8e0b57e60bcafd24864aa69bfc82e5981b" => :high_sierra
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
