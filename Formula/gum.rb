class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.2.0.tar.gz"
  sha256 "85bf131216c5ce7fdfc1c8c72d2eca43d4a57e4ce323792f386317b6bfffb032"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30ae79dfdcdce87d20721f37a3bc86886dc6c42454508ac2b6343c95428891d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d58952baa1ae4fd2b90a586d2a7c539e5e64de5e92067c2fa8699e59feab2d0f"
    sha256 cellar: :any_skip_relocation, monterey:       "e71b20bc9a7320b35eddd9c97a4763a828a245153329f63ff94c2208cc23a9d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3097be0104abd1f7e901cc0a5d88003e749c8d67232b388ec73a5feb5241be2a"
    sha256 cellar: :any_skip_relocation, catalina:       "8f1724d617c9bcffc0a9c544b86d7d65e5da022876e5a241e32634a7239240a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a924daba3dfe72ff2e97c7f4d08c12c148803d880fb609b61807d919ae3a41d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    man_page = Utils.safe_popen_read(bin/"gum", "man")
    (man1/"gum.1").write man_page

    bash_output = Utils.safe_popen_read(bin/"gum", "completion", "bash")
    (bash_completion/"gum").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"gum", "completion", "zsh")
    (zsh_completion/"_gum").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"gum", "completion", "fish")
    (fish_completion/"gum.fish").write fish_output
  end

  test do
    assert_match "Gum", shell_output("#{bin}/gum format 'Gum'").chomp
    assert_equal "foo", shell_output("#{bin}/gum style foo").chomp
    assert_equal "foo\nbar", shell_output("#{bin}/gum join --vertical foo bar").chomp
    assert_equal "foobar", shell_output("#{bin}/gum join foo bar").chomp
  end
end
