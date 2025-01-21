class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.32.7",
      revision: "6b5d24f5741a1789fb97ba3e11f0ee868d93459d"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f018f9b3527fdd582a36ef4cb53724ffeb5aef80c125d0577ca6a48317fa33c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f58c5a81f0e2ef25f9affdce23291ac6aa4cd7d2990de5eb4f281a47b17c236b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7574d4b0d8a8e57f49bb29c0039bc0205ef0923c1cee321055077e6284f7440"
    sha256 cellar: :any_skip_relocation, sonoma:        "aae9d0e3e147ca475365b95fc0fa5d2ba30f467d0d7bb4b9a8ed2a1329cbfcb4"
    sha256 cellar: :any_skip_relocation, ventura:       "28f46e462ba3764a6774600c5786ebfb64c194fa72fc31ccc2dfdbec9db334c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "221e50e67dcdbe8126c5764500961104a1a1d0cbbbd1c4447f84cea6697e4a15"
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
