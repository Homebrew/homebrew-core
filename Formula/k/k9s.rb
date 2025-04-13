class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.2",
      revision: "bc22b8705304b86c2f4c417a088accdfed13fdf8"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6211317d6b45817b89532373ed66e410afd5481c6f8d06f0749d8ad21a30db6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a7de69b70319fd8e53488cda84d5ed0125de17ff1eaea25eb02e04616001e26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30869dff2a927ce13498835233fc5a03669fe8f808babc576f0a162c06050f0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "26ec0c419c1abf7776e0ac33243ce0a241fa726fb8cadfc8d84d0e623819910e"
    sha256 cellar: :any_skip_relocation, ventura:       "a6e4748c66e5d6e1f998f335a05a315fd384dc3cc96d6609aa29bc1540a0a031"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ccbc4c97882e15772ef87dd411f5c27f9682dc5c7645f363ebb8256bcafb398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "212e7ebf57cdfe0090a3fe61547e101ef612a853cd3a49b81e3f7388642606ce"
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
