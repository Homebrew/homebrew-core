class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.7",
      revision: "457e4b86db896d776e2be7401de88002a8b04932"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a850377ba58a7df1ec8103f136222fdd148f3e8a31030179b5b21b1075cee5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3cf75c0fe97741c5b3a26fb5a3f52517778015cee0440d61d50e211fc08dff7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09084a15b501a02bf5178e7c629823244937035687d3ac94cc041a52bcf32a9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8135174450e576b2b4ce01e8301f7019b4677e84b072b256281dcf3cfa0577a"
    sha256 cellar: :any_skip_relocation, ventura:       "075dcd99475e1e804ea329a2b37c4d7104bf0943900fedb0a1f92a960a0ff7d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5720021bcd2a9559ed8a0d1452abddfb57fbca34dcbcc3525edc835846310517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed224491889189d1e6ccb07f3f580e0193119a57f0fd42fc9227ca0f6072f24e"
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
