class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/refs/tags/r34.tar.gz"
  sha256 "9c78735fa88c0b77664d7de41e7edbbca99ace5410f522530307244a09839263"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c43f6aef68d5e4b161b51422bf6e52854a0e5f069964f890da9f32cf356a46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32c43f6aef68d5e4b161b51422bf6e52854a0e5f069964f890da9f32cf356a46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32c43f6aef68d5e4b161b51422bf6e52854a0e5f069964f890da9f32cf356a46"
    sha256 cellar: :any_skip_relocation, sonoma:        "8121711616718f0e6c1ee32067bcfb8d408ebe5a4e8ee49a6b0c4005341237ba"
    sha256 cellar: :any_skip_relocation, ventura:       "8121711616718f0e6c1ee32067bcfb8d408ebe5a4e8ee49a6b0c4005341237ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58f50f255e1b6b92affb5a2ab9cc0441c108b8a8b16bc10e441c3cf75604793d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")

    man1.install "lf.1"
    bash_completion.install "etc/lf.bash" => "lf"
    fish_completion.install "etc/lf.fish"
    zsh_completion.install "etc/lf.zsh" => "_lf"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
