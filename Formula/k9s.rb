class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.23.10",
      revision: "a952806ebaa316e2c7d0949ad605fb4c944f2cd0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8df0581b881a4af5da917cc332f1886d3cdd3128669a56aaea9f161c890e6d8c" => :catalina
    sha256 "4e4bdc4f871e528812a124f63cf100d04c632fb4ef41adf3a8976e2b57a84938" => :mojave
    sha256 "a5ea95ff63c705a3081f5dcf094a0abc0024601e8fcf098a7a39e33a4a5cc6db" => :high_sierra
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
