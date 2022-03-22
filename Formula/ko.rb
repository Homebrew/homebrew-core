class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.11.2.tar.gz"
  sha256 "000045afa2eaee9a6af475a41fb60541b39e2e7bfb7b985ff7b1040b6bc2c58c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f19009ccf2919f0e12549859339e73f0f6c48225f4a1a96b974592510a310717"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e210382936bc911aaef9f61e511b2b9acc9f174c148bb9c3c0cac16656c75d0"
    sha256 cellar: :any_skip_relocation, monterey:       "1033fffab960c8d00d7b7b88d8701c2f9377b3aeadb5d297ea1e0b47371956d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3374d1d5a995a787b0d3ffed8e2b0b394ca48d7405a7fe95433a0dc6909fa94"
    sha256 cellar: :any_skip_relocation, catalina:       "6374fc04b544c01ec55c5e37e3ff271bfdffec480091ff9eb42a86d3c9e8dbfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a67045c32e69be1a60b8bde607b02d592c7cdda6340d2de0771118d517fc852"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    bash_output = Utils.safe_popen_read(bin/"ko", "completion", "bash")
    (bash_completion/"ko").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"ko", "completion", "zsh")
    (zsh_completion/"_ko").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"ko", "completion", "fish")
    (fish_completion/"ko.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
