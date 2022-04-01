class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.3.9",
      revision: "4dc66c946ca2f90f5f7a5d360a573698687a3a11"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c73209136e109ff8d5adc4c711124fa6db936464f7eeb5985c28c78f79592c42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "506a0d781ac1970085e82b745a0de04a02a1a1b0b304ff85ab6d7a3fe8b1f2dd"
    sha256 cellar: :any_skip_relocation, monterey:       "874f72342c86c0d6e0d4b60579985ee1664a11f60c9992ceddcd0de9ac35fb76"
    sha256 cellar: :any_skip_relocation, big_sur:        "f00cd48be8faf992adbf09f13ded9e22c545eedb4ea4913a75611da3044ba3cd"
    sha256 cellar: :any_skip_relocation, catalina:       "d20c39cf55d97f255f0313b92d306c9a25bf0e16d61fd81a43b12ace61a1fc53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1259b69247022f390fa78bb0724753c5454375243bff8d251a0c9a0b1df670"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags: ldflags)
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
