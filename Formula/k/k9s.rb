class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.6",
      revision: "13cb55bb66272ac4c872a1f6bfa3e820d7d0ca5b"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b4782a6a36187c4be44627ea3b1fdf55a5920d891f63ce2c3f26a07635b727a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "000b37707c256307e87a5ce8ad5cdb7e3ee9fc267ce467a8f9106ffba942e9ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39d137be443dd9d3cde514cf08d00172499c3caaceecca5cb9af6c0dea77e5de"
    sha256 cellar: :any_skip_relocation, sonoma:        "f88480359dd74b5bf2e531ac2d559ff3dcd26dc85f6f983e13dd03d0d2b06002"
    sha256 cellar: :any_skip_relocation, ventura:       "13516cb513b257c631e0901fb0b9a458897a4389dcfaa379c10bfda17f4e0439"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ba23fb906e9c11de1f99f002718e3b27cc81949959b5a6e397a8ff2dda3f384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92298d177ec5184d1c96a15b658d4c23ed6dee80c09fa51e795028fb3e5b3a7c"
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
