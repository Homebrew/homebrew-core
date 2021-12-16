class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.13",
      revision: "fdc638c5d47da880dacbdb88c3241c20332a7990"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71beb766a54ee3cf16b0630bf740749861520165b62ec45e2b5f3d30450820ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f77de4eb89b24d3187c5a71f93bfe15ba9d4b1f1db52362e437f9cb187902cee"
    sha256 cellar: :any_skip_relocation, monterey:       "9b5266f90469582ef3aeac5a949e0d616c81fcaa632d29f4ac11ee322431fd52"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0f41b4d6b05be906c61f256bb76db25e25ece58cf8f044a50d86357144a226e"
    sha256 cellar: :any_skip_relocation, catalina:       "9c02bdf5c910d4b67beeef13e203db27f30391f0d2b94ef2f049cb353666919a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb469bce5b8dda63889972746536236588c0673b21031bb47997632f9338933e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"k9s", "completion", "bash")
    (bash_completion/"k9s").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"k9s", "completion", "zsh")
    (zsh_completion/"_k9s").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"k9s", "completion", "fish")
    (fish_completion/"k9s.fish").write fish_output
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
