class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.13.1.tar.gz"
  sha256 "17372332ce8f2b5d4ec61272ba600a23cf74416440d8056fb4aa4f00a47d0bd6"
  license "MIT"
  head "https://github.com/profclems/glab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1990f87844efdf4370288f618981d7b5dd93239c3f9b54945722d4ca0b104ee4" => :big_sur
    sha256 "159e4ad454d9dc47e81a0db5adde8cfdb6d1acc9dd7c87f93ccf9ec52ef127a1" => :arm64_big_sur
    sha256 "d4915546e4b3dd8e60c68af7667f24cee7ad6d7f0e9d9b56b06f6e413417d014" => :catalina
    sha256 "2567d204f66b68c24c759ea3a723a4ce4b4756c6d99221076755b0665846081a" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"glab", "completion", "bash")
    (bash_completion/"glab").write output
    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"glab", "completion", "zsh")
    (zsh_completion/"_glab").write output
    output = Utils.safe_popen_read({ "SHELL" => "fish" }, bin/"glab", "completion", "fish")
    (fish_completion/"glab.fish").write output
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
