class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.10",
      revision: "4f5c1a1105974e8bbff9a0e145c9a8f6b642a21d"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bc059b7d6ae6016f1d0b2fad717b5c6be43fa18d52d42c8dc4d77cd8992a42a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd2bcceb5dfdcbfb0ec6ddaffda3652f0d546383ba8e99027b505e756b9f5a43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16efe2f53f5fc9d628bf68178416b901a4feb0d98cbd04cf648e52e85ebe52b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "04936c860742ce5965f2e177768b4b966d19d15a98267632da30ae04686e57c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8eaf935fac1c8dd184ba660add325e739f18909171420ed619d95e9ceab7b90a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbd30b4ed50e4f0c6c8b0ca4f0b9b679ef0ebf91e84d958c9b4dd8b09b23447c"
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
