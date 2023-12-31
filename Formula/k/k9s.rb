class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.30.6",
      revision: "6a43167f1a30db50ed2acd4e3ffcfad25f657679"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc76d773a64138733434520aa57efa3783b94cb48377c747902baec47801875d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64a25b560f16f3a344882862338232bbc52d33d4e89747755e85acf419817e14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e1600b41820dcd5040b6f954e2bb1aee98b775362e4cecd0b4e3fa1153a0989"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c9e1ba63eb86af3a46ebc8cf28482a5a6871d08ab1252af72c9f8a58d1f7cdf"
    sha256 cellar: :any_skip_relocation, ventura:        "12d1c098d7ddb302c164108938f1c1d1d0bc0ad96971d73007a5143537a12d0a"
    sha256 cellar: :any_skip_relocation, monterey:       "2762cf760a3aa0fcaf98eda14ddfa7a6269fa98b0ba3c9c4af0a35fa090303d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b54b78fd0cadee6888c6f59dd0011b599b827af4543abd0b61ea7a3c6cf5e1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
