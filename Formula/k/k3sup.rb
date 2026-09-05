class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.13",
      revision: "2fa773c9db8995a193d9ec7a79db00944931525e"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e7d9ce78ed5d93e59185b0c00949d329ee5104f942de2faafb27804f6a8d8f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e7d9ce78ed5d93e59185b0c00949d329ee5104f942de2faafb27804f6a8d8f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e7d9ce78ed5d93e59185b0c00949d329ee5104f942de2faafb27804f6a8d8f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "713f366228e5eb09801d6f6336bba0beb2b703a52ffc87b6df4ad8063106a31c"
    sha256 cellar: :any,                 x86_64_linux:  "a6e20f89629c4818fbc4a4b9f6045fefa20721bdb4f646b616303b509110d7eb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k3sup", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
