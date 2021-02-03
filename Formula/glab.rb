class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.14.0.tar.gz"
  sha256 "927206802cda67f0b725d0ed2b355a67ab9eb560a9e8b8c6e4ca994d9aba3daa"
  license "MIT"
  head "https://github.com/profclems/glab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "775c3e023957dd12d19b02f1ba08b8c86edb03f2ebed88864701ed7849bd4335"
    sha256 cellar: :any_skip_relocation, big_sur:       "74303c1e17dcaf2fa5a5f20fa9eb6be2078b0ab9553732bdf62b1db80cdaa55f"
    sha256 cellar: :any_skip_relocation, catalina:      "0f8d551f3923620d64d425471f7adbf09f153ad13ca3975aef97f27aa8fe5306"
    sha256 cellar: :any_skip_relocation, mojave:        "1e72168c56caa2c7109e33b690a501de48c32c08d54d6ae90751567c57db9af0"
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
