class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.12.8",
      revision: "018b1a0b08c2c08f0243b9bb7b0139868d1059eb"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baacc1dc3ed2a20359828e852f24441f330dcd851d778d4f111f412c4beaec3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d35e8db5be9ac8b7fdc2b8990ca9e38284de3227f40cf96e1fc21883b67effe8"
    sha256 cellar: :any_skip_relocation, monterey:       "1cdcf6b302b500ec1f0194ac5e1d169fc4dc087fd636e4a518065749670206ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7ad9898126a08f967f05273b4b0b731963542c0912ab610f2e3fd8989d5bfeb"
    sha256 cellar: :any_skip_relocation, catalina:       "c8fc506b9e8cba697408716bab8ac6db412557c8db527cf38ff67ede93cd9d3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3b52391cdd056fdcd68645736b4229858ca4fa056fec10d17938106b871673f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k3sup", "completion")
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
