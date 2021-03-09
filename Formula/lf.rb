class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r21.tar.gz"
  sha256 "088510cc1f86084c02353d55e56a8c44576b5dbfc37327daabaa86ae6b287a20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a260e0a910d03324023d7999f019075804b8243f7a68ab86a6e9667daa052b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "b6e1195a6710c0d5554d4457ff24e3d7aea47504415474edeceb61fd936eea63"
    sha256 cellar: :any_skip_relocation, catalina:      "2b8abf2a0dfa91390d11eeaa88a26ac00563ea1698f2b997c99bbebc7f4d8300"
    sha256 cellar: :any_skip_relocation, mojave:        "ffa6a3732dcaa2077472aa4fb8bb6f0f12dd1acf2f2d8d33561975724fbb14de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.gVersion=#{version}"
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
