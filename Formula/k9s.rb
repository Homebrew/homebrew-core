class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.22.1",
      revision: "2e04a846e668f67af207a1030a310b5e2c864231"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d27c043bb7e723d435f1425ac34013c0d1bcb778df5a5c705fe173aa73d4fdf" => :catalina
    sha256 "7e7feaaf383d1057390c55fe272a432d401219028caf2a90928733d923beb83d" => :mojave
    sha256 "821e10a44332317b44e24b1070644791a09fb3ac8ff5568818c8ab69a915d6b6" => :high_sierra
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
