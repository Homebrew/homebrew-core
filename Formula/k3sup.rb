class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.12.7",
      revision: "e3ff08cf1d3798c7d89372f30a79b5fd4a1d2500"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c6fe3e429eb80de77c2a3881ccf657030021d6e67613b2ff9e636a08d34e283"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "342ed4f72e9307b4d199048382b1255e509d5151f47ad51258429bd08322345a"
    sha256 cellar: :any_skip_relocation, monterey:       "b51466716194e22e398e30812cccb273c1a05f2503e20c1935539899e63a9cb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "005ca34165067c1c27ad12e20cd3981cfc62afb1b997a6b4534e5777a0c0bd09"
    sha256 cellar: :any_skip_relocation, catalina:       "9f36a27b5eefab6d18aacfbc0046d3ad21645df53757760be17ebef9724b2e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2d05f33cad91bb047544404f2e4eba158140aeca7f6c874eeb9975eac909fae"
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
