class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.9.0.tar.gz"
  sha256 "27dab5c8ca25e09794d54d7610064bea37a4e0c471d4e0a8a6835727a27a9a0f"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd772298955d7d90bad4bbfecbb77c2c5c95e58ff36c25f87f40435d259f5d2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44729bc895716cfd473f137572f3c1d710e2a0066f2891ccd9919c9b30c6af86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d407a429562e44a542aa015e92cec1ea729f94b230794962acf1c0f425e29003"
    sha256 cellar: :any_skip_relocation, ventura:        "20d286a734e0fa4078334e69e28e660ee7d16ae2c6e8aa1005e2e49b28452864"
    sha256 cellar: :any_skip_relocation, monterey:       "8ae16d197dedfe61b2e976c3837e5f48c2761118aef2191fc22723341cc0bae0"
    sha256 cellar: :any_skip_relocation, big_sur:        "102911871d328ccba13cc140b1b7489cf0fb50698f3da7606462640728beff18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bee76272497a0828f8f1911e208e5c3af75d9365091e14bfa1624c872420d75"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    man_page = Utils.safe_popen_read(bin/"gum", "man")
    (man1/"gum.1").write man_page

    generate_completions_from_executable(bin/"gum", "completion")
  end

  test do
    assert_match "Gum", shell_output("#{bin}/gum format 'Gum'").chomp
    assert_equal "foo", shell_output("#{bin}/gum style foo").chomp
    assert_equal "foo\nbar", shell_output("#{bin}/gum join --vertical foo bar").chomp
    assert_equal "foobar", shell_output("#{bin}/gum join foo bar").chomp
  end
end
