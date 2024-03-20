class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.32.4",
      revision: "d3027c8f2916b23606f647f47b434b08fc34bdf8"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51bc2d04e3f85c41512c1008c1f4856194a1aa51271a5c8329d4c7309c4c60b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4d3d2f22bead80e2f9890a6a05424e1e53ec1cc28bebea6f91467cc596ae951"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e270e546e5527fa7db9b0a95df139bad4503224607e2d1075a4353d099196f08"
    sha256 cellar: :any_skip_relocation, sonoma:         "b57ab1ad659b3766d1d48701fa3bf0cf0f2c9c441c42219280a0f53f1c1739ef"
    sha256 cellar: :any_skip_relocation, ventura:        "f55b96fcf75059fec85f6edee47e4b92615f3db5e029c12f86191b571d760f5b"
    sha256 cellar: :any_skip_relocation, monterey:       "27063d0e246e0fbfbaeb50b43f53d7827f67630d67f0194e4f420242490a8255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e0bfd1549ac8a6e9e732cd477deadec556e7041248f9d00b1523aa92fd3d571"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
