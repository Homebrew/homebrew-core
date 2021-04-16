class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.10.2",
      revision: "de10fc701f46d7d3676d29769e6a73efc1429225"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5dba59d4f75027783dae204b77940a49f9698049bb0410bccd528b3333930a33"
    sha256 cellar: :any_skip_relocation, big_sur:       "0a61dac1155673a17a07d454c19b3f477888c7288571fc661624458182e93ef6"
    sha256 cellar: :any_skip_relocation, catalina:      "02aa3ab948053108d81112168c9059eb0f746fb74fec676d70a33a0f947b3609"
    sha256 cellar: :any_skip_relocation, mojave:        "12df349e16c4912631517ba6c919f32f2a48abd46e082c290d40c8ca3da6b468"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
