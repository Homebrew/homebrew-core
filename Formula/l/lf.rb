class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/refs/tags/r40.tar.gz"
  sha256 "43a78f66728dbbbd6848a074dd3d70e8ce7ef22e428de81a89bf2da174226a26"
  license "MIT"
  head "https://github.com/gokcehan/lf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eec19e90a76c79977f50905c2c58a99848885aee644e6454067e3e817e7a56e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec19e90a76c79977f50905c2c58a99848885aee644e6454067e3e817e7a56e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eec19e90a76c79977f50905c2c58a99848885aee644e6454067e3e817e7a56e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "aed00ba1475bd30e78b7b1f1f9d7b0111d874f0b5fbf322ffaed3411601b9908"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f923182b622f416b96e37b6636ce9f4ea99115bbab720994729988e95dcdda2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1baf53105bdea7841406f30352c360e6dc46a05dd06f90b45d0a27a2d518766f"
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
