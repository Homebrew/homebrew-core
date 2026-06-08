class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.51.0",
      revision: "558caafe7ba067467de46b320cc22ef11fef9c34"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15fffdcadce29edb0b3b8ea6042dea1e49f3697d2d9b93be135487f9c7d8ea39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a168ca99bcb4cf901567a62c6b0c575394743733bd9c57771cfa4c992e97c81f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a3bd6f4dc0a8bbf63dccf5134766dd39bb020ca957bb6d02757b281171c6eb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "779126e1675719eb42a8318079bfcd7a70bc7ae694dd4ad9a9b95c5817500306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74602c41d374584e93afd24db2349db909fd9255c0327540d427ae9ebde04149"
    sha256 cellar: :any,                 x86_64_linux:  "a2bd1f6f58940a035e5a5090cc261365106e78449f099661a4b7a87f491fd4a6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", shell_parameter_format: :cobra)
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
