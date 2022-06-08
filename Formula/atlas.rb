class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.4.2.tar.gz"
  sha256 "d950e9f665cfb8b556c4f921e9d642e9628c1c8c788fa2b5ef9ddcb32d8751e6"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c1e048eadc2fe61cf0091e2a0615bc14e9218329ea93f62991c2dee7f600a1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aaecd2825b28405ce039fd698d32085137852c5a6d7f3739541d1f50e4714f6"
    sha256 cellar: :any_skip_relocation, monterey:       "cbec4cc6c918f09c43c1772b84920cecd63384e7175bfe3fc9c1e5d078b94c78"
    sha256 cellar: :any_skip_relocation, big_sur:        "645dddb2f3ea548fe76270e33754d726da0367fd691e9f00004d0260fade563f"
    sha256 cellar: :any_skip_relocation, catalina:       "973850f7f80663c2041bc34ab3533339295a8b51c43741c5b71a71fe1b35715f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83456e28fa4832f2209e6166e91e250aa5130230126830796f4eb5fc0b2ca814"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlascmd.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/atlas"

    bash_output = Utils.safe_popen_read(bin/"atlas", "completion", "bash")
    (bash_completion/"atlas").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"atlas", "completion", "zsh")
    (zsh_completion/"_atlas").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"atlas", "completion", "fish")
    (fish_completion/"atlas.fish").write fish_output
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
