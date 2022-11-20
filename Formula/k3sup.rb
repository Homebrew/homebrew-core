class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.12.10",
      revision: "769a8e8a8f0b2397d5422a0d9c6cfdfb78de5d36"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e08ffec344a92947c29923a13b91a2d8d32c8501687f05e1469a8a02f61fec5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7976530c27ea3cafc1298946808444ac0f11356eda94964c8843cc008838ec1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "458a0d1b7644fe0bcdd163287ea78de174b2ccf40a7bb3428a8ed1705b20be4f"
    sha256 cellar: :any_skip_relocation, ventura:        "65365e05c4af2c86353391dd454c7071779b86a959354db154469f6d5f028f59"
    sha256 cellar: :any_skip_relocation, monterey:       "5ceae0674f5361d7414923f69f479456490454ef8c821566422d90d06825dc23"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c35c93623857b785b71c5562e2c91fbb77024505846862dc5b820cc495d8754"
    sha256 cellar: :any_skip_relocation, catalina:       "56ddd0285b5ade55f932d950edc1f817c888cac433252fb1a47630cea236e308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ca681c1d611fab961d674be0fe1217a973a583e184e1355ef67055e3ec0b3d6"
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
