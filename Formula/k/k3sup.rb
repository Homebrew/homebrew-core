class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.1",
      revision: "16f009cd86de432fa78d08fffa1c12faf9d4c896"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94935d2b2317b44f2acb98af80c3dac757d801f4a2a6b479d462165bf85c7802"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7397beacc24a9dfe5579f0f035e7de238276473f274782797261aef0dac7d35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "505feb5ac11ea09b278f5f4869f8f9e8374c927eda5e5df4ea6bf094811cc67a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43581e92c30ab51c209227453cc39121daa27a1777e537f32f62c7533b8668fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dba537c5e100d4d2a21d1112c632a49e5f7d07357dc40fbddf10c8b145dbeea"
    sha256 cellar: :any_skip_relocation, ventura:        "115ba3e4fb90d7a2450af548668f6ec1e35a8865b3c175e9e618dd0c42f59e89"
    sha256 cellar: :any_skip_relocation, monterey:       "d89121a1fd07ca98e94097542b5ef9deb5f234dd02e0c7b7f73f8199fb7919b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae84f86f9e97a42d7a80958eb02340fefdc3c9cd23e4efa1f5281e4c876064bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20c8c952671dd39cdf650976fba93e94ceab6cf0be62b44d1b0f94a1bc0f3a69"
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
