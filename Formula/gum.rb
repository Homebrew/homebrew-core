class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.5.0.tar.gz"
  sha256 "0f8e071cc3610c641cc0539f7feb9652b0e8a1fa8f7409c81625cbe71027f28e"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b401b8b550333faf80cdb4dae67bb7be6d32ecd8dd38e2202a3ab9c9b26bb596"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c290e9f2be2d9815dc2211da6b1f472c7eaf52028bb9536d310b5d3a9e72e4a"
    sha256 cellar: :any_skip_relocation, monterey:       "782dce22d8058637675fb90c4be1107cf58a1ff2ddb6668d2caba65c74c60867"
    sha256 cellar: :any_skip_relocation, big_sur:        "25cabd307a5ab1f5073ff6fd0843a7a012d00fa149639a8af1170a8b3275e9b5"
    sha256 cellar: :any_skip_relocation, catalina:       "92d532916b69c9289aeffa7ea420035fc3a43f2e02e71d271ce03f7c66ac07b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "554b990812e09bb1c21384b3d9dd033f81eadab76f22ceae505179f1a32d39ca"
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
