class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.12.0.tar.gz"
  sha256 "b95ea6fb00014c5970650203cad1243ab277f7f6ee84950d3a036c1ee6cefc8c"
  license "MIT"
  head "https://github.com/profclems/glab.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0d0c63b8389b0e7034effccc9d970395c2b8b85a6f92a4169cbf54b4ae93d589" => :big_sur
    sha256 "f16fc3e38d554c0238f6b5230c207a0bccd0b20f3f27ffdf088c37d488151170" => :catalina
    sha256 "fd391d0782e5f76604ccdde46032484d50b844a252a50d241dab0656cb98efd2" => :mojave
    sha256 "62f911797cee3981fc9fea930d638cc1f1ad76faa80daa6383bf0ebf7ecfbc44" => :high_sierra
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
