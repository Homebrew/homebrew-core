class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.20",
      revision: "373fd4587b69d5e97eea1319b86cbb68f82a266e"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5540ac357828fe7878b447642d04f92a04e2d687c377b4fe4febe07ec731d78f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "860f8e84f986c88eb23ce951c3b888731f2cf5b427293d9284e5adfee1affff0"
    sha256 cellar: :any_skip_relocation, monterey:       "ad3d48a4cde807f81b1a462ad698a2d70d998ccc6efbdaf42fc8cef9f0c7ff16"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8d475b2c8748e0f8319ffaf63ce46fbd504386c849353d2895b4425b6003ba4"
    sha256 cellar: :any_skip_relocation, catalina:       "b7131a19c82fd444a229c3760d331c882701ee35d932f6bda86b16d1409eda46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b803e95c5a1e63be43eb3d61de506e3cedc05d9a3abeca8c88f5a6cb8aba103"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"k9s", "completion", "bash")
    (bash_completion/"k9s").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"k9s", "completion", "zsh")
    (zsh_completion/"_k9s").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"k9s", "completion", "fish")
    (fish_completion/"k9s.fish").write fish_output
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
