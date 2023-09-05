class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.0",
      revision: "1d2e443ea56a355cc6bd0a14a8f8a2661a72f2e8"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9bc8a35f8246b7c7371d05f166715f03d1ab4f3a9a69d81502d2aa27cc48743"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9edd31492d241247bb78b54f3ebe01114269a6ded3d13785d990459cb0ac7a95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ead908eaf645f6b46b6fd047c91a015eba60d90052b5718f7244634c3c96e50"
    sha256 cellar: :any_skip_relocation, ventura:        "01e366718e215f5d617ebfd3f90af1dff539cb405ea32dab97267bc1fe45f2f5"
    sha256 cellar: :any_skip_relocation, monterey:       "00af0f6a8cdb87e85f1b1c91e7527b4e91110f297471da521080a2780796a2b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf4db7491b62b36d9d1537f5344aff9e5b6b756c967e8f4a7cd4541d33a6294e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "891f16b3c96614a6b906f5aa8c67302a47cdd340323ce720323d21eb2f2093dd"
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
