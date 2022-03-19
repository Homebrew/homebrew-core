class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.is/"
  url "https://github.com/juju/juju.git",
      tag:      "juju-2.9.27",
      revision: "acb32588d1752e813b36e3491f0eb44cde7c0684"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^juju[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bba044343e44a51f96b4c7933683ee796e8e3caf2a95548440ff2262b2b0027"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e0c5784916c694f1526612b2e1a0fffc0133d6355b3b126a8ea4b19544be3c3"
    sha256 cellar: :any_skip_relocation, monterey:       "340f9ee81d7866084e2057f9eddebbef8f963c912bd1e0b2fbfcb9185290c42c"
    sha256 cellar: :any_skip_relocation, big_sur:        "69c0279a748d222b3e10d082d07035438bb5fc1244d354bcef48ddc9303d72f5"
    sha256 cellar: :any_skip_relocation, catalina:       "db3e72d226dccbb5207db35696d84ca27143a70510c5dee42d8ba2506263ff8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eba36893043e00f6caa0a6433b57dfb0056a473faacafebe4a6d3af62bf2efa"
  end

  depends_on "go" => :build

  def install
    ld_flags = %W[
      -s -w
      -X version.GitCommit=#{Utils.git_head}
      -X version.GitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ld_flags), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: ld_flags), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
