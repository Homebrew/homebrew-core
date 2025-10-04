class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.13",
      revision: "1d8cb6ced0d0f1231fa6bd59f165277d7416b736"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f302b7c18583847b377ba5551e3e7c90575be3df8a119b6b5efac1a82a4ad5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79e4034d25016441379c5360fe03ad592d704d127422a3c0590a49d531f9444e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a662896505b640d50567e8c03a9a6f03f66d853087d7728aa1db72da5267f3dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "68a829b8518ffb13d197c8abc4d1d5f6ce30814ae7dc4850e0f48890b6dc3886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "342298787dea5d7a5e0900b9cc8378b8f171dea7b4c2f78ffd69e00da4cfad1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a14422ea5904d32d7cbab9869fcfcf017f3c9d2ab82d3831786b6ca4e197a0d3"
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
