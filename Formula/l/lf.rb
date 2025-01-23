class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/refs/tags/r33.tar.gz"
  sha256 "045565197a9c12a14514b85c153dae4ee1bcd3b4313d60aec5004239d8d785a0"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b73917bb1a1a185066914f34517edc4a27edb82033bc9e68ed08192606887df8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b73917bb1a1a185066914f34517edc4a27edb82033bc9e68ed08192606887df8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b73917bb1a1a185066914f34517edc4a27edb82033bc9e68ed08192606887df8"
    sha256 cellar: :any_skip_relocation, sonoma:        "af2959ad101da355e679e0ec0da5b3030ce33f22a77f943e7f979fa20f4cbbaf"
    sha256 cellar: :any_skip_relocation, ventura:       "af2959ad101da355e679e0ec0da5b3030ce33f22a77f943e7f979fa20f4cbbaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d460b6949281a75c36a857d5bd84c23919171ee6dba0a782da87487682a2acc4"
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
