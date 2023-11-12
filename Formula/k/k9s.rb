class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.28.2",
      revision: "694159b857314de5b69f251e42a5931f32105cb8"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "570187ce84cfc93401eb1c54eac248e95fc0b29a2c2fa8d4d746b153f01d69d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a47ce0d4cab1a7f84b4d8454590d3347fec2634232e2ec257fb474944eac72f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7349cfd7fadbd1ab70f44c493369ce06f813b8f24ea0a3ed1cbac42f7786475c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8c4120c67d6198308e1cf93729622546089b967c19655fd1183a38fc1f12a9c"
    sha256 cellar: :any_skip_relocation, ventura:        "2cc6367e456f4c5e36199e0b9493ae5c2ea9aa3872830adeabcc86fa358cced4"
    sha256 cellar: :any_skip_relocation, monterey:       "f8a3abc69670d1717211e3453f664206b24149f82d6aa026c6e795311de44e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1838a28ac9955b2d44d410fa5c07ce735f2ba02fec81ffb4b3e7fe5328149bf8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
