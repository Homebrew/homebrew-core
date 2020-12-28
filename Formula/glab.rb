class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.13.1.tar.gz"
  sha256 "17372332ce8f2b5d4ec61272ba600a23cf74416440d8056fb4aa4f00a47d0bd6"
  license "MIT"
  head "https://github.com/profclems/glab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "384681ff8892aeef81ad705f2e21a10b67964b3ddc93fc33a16699885c59d6bd" => :big_sur
    sha256 "30caf67107c915fc0086027d4a9478c159ee53e96b13f69cd1f9ee582ae99454" => :arm64_big_sur
    sha256 "014a2b65f618d404f64f4a7863a105f60838fedd264f565c52eddd92c11a37d7" => :catalina
    sha256 "75d36bcbe69e51a290e328d25ee60fccb2c10921c1bd419b3b13b98be120a814" => :mojave
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
