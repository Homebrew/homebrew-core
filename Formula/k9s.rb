class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.21.7",
      revision: "cc0e8e88d3d03b57d6251b63cfd3351d3e0d7acd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c92d4c4d6c9e43edd5d7bf482c1fc50b2c6630058f65d0a77bc098e19239b259" => :catalina
    sha256 "31670ba359a0b1f801772c55b1571f3ece42a97503131eafc7c9c23ba60fbf24" => :mojave
    sha256 "721835d94666eb9655824c4f7e8219a6532859c31ea18feecc34de340a40f265" => :high_sierra
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
