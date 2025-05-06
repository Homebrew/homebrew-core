class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.4",
      revision: "e4e38161857a202f09488c7ab3603a27de464ad4"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a94bafcc2cecebf1be02a1c13c2e33b909e4c35f4e89497357174ffd4faae19c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba8b79c24cbf33668ed6004fee5e88ea3d82c882989c8707d1d6c83117c25d59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38044ba9fdbd1206786154439ce4d784ddcb176fbaac354c431a51989120b30c"
    sha256 cellar: :any_skip_relocation, sonoma:        "44d04da2dfdfa46d34d69cf6ba73ee0f624c5926071bdeec25bdd6ad8b867b22"
    sha256 cellar: :any_skip_relocation, ventura:       "00ead77a783f006226e198387ffa7ca6bfbd55b56942cb84d1d7f1d7ab9aea94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74c2b5f4f8d2e1d4fbcdbbdfd29d1a8f51e975a8c315e83b3c2ae06c197babfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95a80cf2819ddefedfb97a017147edaae6cbadd1702fd92f3d4234dc979bf71c"
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
