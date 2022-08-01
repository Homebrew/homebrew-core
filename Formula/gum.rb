class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.2.0.tar.gz"
  sha256 "85bf131216c5ce7fdfc1c8c72d2eca43d4a57e4ce323792f386317b6bfffb032"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e684d88b0922ecda1c592cd018555024c3a0da1b51be9ae1157ebad8949ee6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16fafe515cddf522b55d9a5b627352c8d6c85217391560824c1429b487210eac"
    sha256 cellar: :any_skip_relocation, monterey:       "4abb0c69f58ed2aa01acd6355b03242437a5234ced3f4c362024a328096bbdb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a92fd93dd1caf1aef9a49fd2a6c2e9cdb3b4c092c2919385b2112a1bbd4c762"
    sha256 cellar: :any_skip_relocation, catalina:       "552dd1540e03376d84137d8ee286f8e60dd0722e39ddf903d9a4145e1c587542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd72841343dc78b8f034fbb8366a96c5bb947caa1f2b87990788610e5ca93706"
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
