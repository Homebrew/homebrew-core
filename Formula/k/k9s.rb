class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.16",
      revision: "3c37ca2197ca48591566d1f599b7b3a50d54a408"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34753f104249b6d663e0b5a5b7ab0684c7f3ad3b5e4b08ae9c3b4835b7c1e45a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab014052a0de4a1876e16edd71c2d5bda72ff5c66bd1a1d31177f92e99cb497e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f72d9276dc75c2dcb6722ccad11f1685a196768d3a772b6a546201abfade2a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "36d75eb3db25e252084272ae8b7b3fdcebfcb24545f0489b087122c3f6fc1dc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "677edcf7ac55887c859bee495f5ce8673b6adf9e5bcf103adeb8f5a9ba23a7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01a489ab46e403cb4312710cfa5e0cd13474097f83c8f632fea8833fab8eb516"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
