class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.12.1.tar.gz"
  sha256 "ba7c186de70cad22178bca9fac5933a99546365c249ab957251f03188e31ee03"
  license "MIT"
  head "https://github.com/profclems/glab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "92f48790c9d68ba28fe78f63c80b6273504170353daa091d4ce50def9f32e158" => :big_sur
    sha256 "24e4ed57e81155fa8368719aec2b737484c534da8550c2440039fd75fb9b6d99" => :catalina
    sha256 "c7db9dc9f231f36c13a3791dd70fbebfddbf7817dc8d6cefdd65563dfed0f0cb" => :mojave
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
