class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.18.1.tar.gz"
  sha256 "ce10c93268eb58fa6d277ebd4ed6de254e4365a1a332122f597e295cc11496c3"
  license "MIT"
  revision 1
  head "https://github.com/profclems/glab.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fff5889ab3af5aa55245a1889a44d3cec2942ce0f6fe0a66cf13fc3e6fdbe0fa"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc2a306d76662947ab14955df6e4732bd2cbabf1c8457320f7ba6bb70d697be1"
    sha256 cellar: :any_skip_relocation, catalina:      "cc2a306d76662947ab14955df6e4732bd2cbabf1c8457320f7ba6bb70d697be1"
    sha256 cellar: :any_skip_relocation, mojave:        "cc2a306d76662947ab14955df6e4732bd2cbabf1c8457320f7ba6bb70d697be1"
  end

  depends_on "go" => :build

  def install
    on_macos { ENV["CGO_ENABLED"] = "1" }

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
