class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.13.0.tar.gz"
  sha256 "6154ac62fd385e26291899d75c8d3188bc25d9186ca5115e6693ebff809748d7"
  license "MIT"
  head "https://github.com/profclems/glab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "067a8bb9cfaa93259199eccd5a547305c24580de4d379c35ce530d6431342c9f" => :big_sur
    sha256 "046533288aab0f06c1df69d187e4896857c64bb9d9596a1512e8f625f3ce7a8d" => :arm64_big_sur
    sha256 "8772f1729514811539f8f52bb42101205e1a1bcb1fa3afc49f0196476c4ed3b7" => :catalina
    sha256 "e3a24235b21b7f5e929aee5125ba571a84452233337eda85ff03393b82947cf1" => :mojave
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
