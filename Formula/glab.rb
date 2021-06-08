class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.18.0.tar.gz"
  sha256 "0e83072ad483ccd6bcb76e0ada327dfce65e1770c7841aaa82245dc6e00d413e"
  license "MIT"
  head "https://github.com/profclems/glab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f76591538f9cb5be6473ba060fb78b248a7cbd34a9bfe9373bda7d9f3b9525bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "3a140b824a41738ecbb626854c95a9095da4674ceb5563dbeaed1c5799865d2f"
    sha256 cellar: :any_skip_relocation, catalina:      "3a140b824a41738ecbb626854c95a9095da4674ceb5563dbeaed1c5799865d2f"
    sha256 cellar: :any_skip_relocation, mojave:        "3a140b824a41738ecbb626854c95a9095da4674ceb5563dbeaed1c5799865d2f"
  end

  depends_on "go" => :build

  def install
    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    (bash_completion/"glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=bash")
    (zsh_completion/"_glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=zsh")
    (fish_completion/"glab.fish").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=fish")
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
