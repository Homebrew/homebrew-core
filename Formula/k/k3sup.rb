class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.13.9",
      revision: "a1700f64dcffd249890b13cf6d97f4c120a53e08"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e992cdffa70372fb9c34859b46743200e15c83413f29798c962501921043f79a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e992cdffa70372fb9c34859b46743200e15c83413f29798c962501921043f79a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e992cdffa70372fb9c34859b46743200e15c83413f29798c962501921043f79a"
    sha256 cellar: :any_skip_relocation, sonoma:        "65477f847cb4a33fec045e910c4313f0c8d7f7a3e5b07ad00eb34ae5dfd3dcbf"
    sha256 cellar: :any_skip_relocation, ventura:       "65477f847cb4a33fec045e910c4313f0c8d7f7a3e5b07ad00eb34ae5dfd3dcbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4dc6504f421b47e2d9afe45917df5affe3902e299cad7c861b91c5684050fc2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k3sup", "completion")
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
