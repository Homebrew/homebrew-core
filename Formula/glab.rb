class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.15.0.tar.gz"
  sha256 "d2551b1ae3c8ec61e0d161e8a75efb16fea1e0716eed0095f23bcf5bfbc8d758"
  license "MIT"
  revision 1
  head "https://github.com/profclems/glab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7587c9a18bc675a2b160a75d362a90a5927196e5c1c7d79260cf4bdfc7cb2b01"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d2287ebe64e3c776c88aef4cb4f1b1276345f8ffa4c2f68325a424314606833"
    sha256 cellar: :any_skip_relocation, catalina:      "ff37b590f989cd2392d70c38c667a6affed2823a24e863a7d1ab16e36b4958ca"
    sha256 cellar: :any_skip_relocation, mojave:        "bd27068df5007c6d1b6a7edda3b06b031df65c9f59fdffe8e1b6f14051d452f3"
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
